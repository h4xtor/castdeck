#!/usr/bin/env python3
"""
MovieBridge - oversaetter mellem MovieBench og Chromecast / Android TV.

Koerer 24/7 paa X280. Telefonen sender streamlinket + de cookies/headers
siden kraever. X280 henter streamen som en rigtig afspiller, laver den om til
et format Chromecast altid kan (H.264 + AAC i HLS) og stiller den til
raadighed paa hjemmenetvaerket. Har ogsaa en web-side, hvor man kan indsaette
et link og sende det direkte til TV'et.

Kun Python-standardbibliotek + ffmpeg. pychromecast er valgfri (web-cast).
"""
import collections
import hashlib
import urllib.error
import urllib.request
import html
import json
import os
import re
import shutil
import socket
import subprocess
import sys
import threading
import time
import urllib.parse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

VERSION = "2.3"
PORT = int(os.environ.get("MB_PORT", "8097"))
DISC_PORT = int(os.environ.get("MB_DISCOVERY_PORT", "8098"))
WORK = os.environ.get("MB_WORK") or os.environ.get("CACHE_DIRECTORY") or "/tmp/moviebridge"
IDLE_SECONDS = int(os.environ.get("MB_IDLE_SECONDS", str(3 * 3600)))
ENCODER = os.environ.get("MB_ENCODER", "x264")  # x264 | vaapi
MAX_HEIGHT = int(os.environ.get("MB_MAX_HEIGHT", "1080"))
FFMPEG = os.environ.get("MB_FFMPEG", shutil.which("ffmpeg") or "ffmpeg")
FFPROBE = os.environ.get("MB_FFPROBE", shutil.which("ffprobe") or "ffprobe")

SKIP_HEADERS = {"range", "host", "accept-encoding", "connection", "content-length",
                "x-requested-with", "upgrade-insecure-requests", "if-range",
                "if-modified-since", "if-none-match"}

# ------------------------------------------------------------------ log

LOG = collections.deque(maxlen=500)
LOG_LOCK = threading.Lock()


def log(msg):
    line = time.strftime("%H:%M:%S") + " " + msg
    with LOG_LOCK:
        LOG.append(line)
    print(line, flush=True)


def short(url):
    try:
        p = urllib.parse.urlsplit(url)
        s = p.netloc + p.path
        return s if len(s) < 90 else s[:90] + "..."
    except Exception:
        return "?"


# ------------------------------------------------------------- sessions

class Session:
    def __init__(self, url, headers, title, force, start=0.0, subs=""):
        self.url = url
        self.src = None             # hvad vi egentlig henter (fundet af stream-finderen)
        self.key = ""
        self.start = float(start or 0.0)
        self.subs = subs or ""
        self.duration = 0.0
        self.dup = False
        self.req_start = float(start or 0.0)
        self.subtrack = ""
        self.want_da = False
        self.da_done = 0
        self.da_total = 0
        self.da_ready = False
        self.subrev = 0
        self.tracks = []
        self.sub_info = ""
        self.subs_served = 0
        self.last_prepare = time.time()
        self.headers = {k: v for k, v in (headers or {}).items()
                        if v and k.lower() not in SKIP_HEADERS}
        self.title = title or ""
        self.force = bool(force)
        self.sid = hashlib.sha1((url + str(time.time())).encode()).hexdigest()[:12]
        self.dir = os.path.join(WORK, self.sid)
        self.created = time.time()
        self.last = time.time()
        self.proc = None
        self.state = "starter"      # starter -> konverterer -> faerdig | fejl | stoppet
        self.error = ""
        self.plan = ""
        self.stderr = collections.deque(maxlen=40)
        self.source_seconds = 0.0
        self.output_seconds = 0.0
        self.seg_hits = 0
        self.trace = ""
        self.segmented = False
        self.fed = 0
        os.makedirs(self.dir, exist_ok=True)

    @property
    def playlist(self):
        return os.path.join(self.dir, "index.m3u8")

    def segments(self):
        try:
            with open(self.playlist, "r", encoding="utf-8", errors="replace") as f:
                return f.read().count("#EXTINF")
        except OSError:
            return 0

    def alive(self):
        return self.proc is not None and self.proc.poll() is None

    def stop(self, why="stoppet"):
        if self.state in ("starter", "konverterer"):
            self.state = why
        if self.alive():
            try:
                self.proc.terminate()
                self.proc.wait(timeout=5)
            except Exception:
                try:
                    self.proc.kill()
                except Exception:
                    pass
        shutil.rmtree(self.dir, ignore_errors=True)

    def info(self):
        return {
            "id": self.sid, "title": self.title, "url": short(self.url),
            "state": self.state, "plan": self.plan, "error": self.error,
            "duration": int(self.duration), "start": int(self.start),
            "da_ready": bool(self.da_ready), "da_done": int(self.da_done),
            "da_total": int(self.da_total),
            "seconds": int(self.output_seconds if self.output_seconds else playlist_seconds(self.playlist)),
            "segments": self.segments(), "age_min": int((time.time() - self.created) / 60),
            "idle_min": int((time.time() - self.last) / 60),
        }


SESSIONS = {}
SESS_LOCK = threading.Lock()


def find_session(key):
    with SESS_LOCK:
        for s in SESSIONS.values():
            if s.key != key:
                continue
            if s.state in ("starter", "konverterer"):
                return s
            if s.state == "faerdig" and s.output_seconds >= 90:
                return s
    return None


# ---------------------------------------------------------------- ffmpeg

def http_args(headers):
    ua = ref = None
    extra = []
    for k, v in headers.items():
        lk = k.lower()
        if lk == "user-agent":
            ua = v
        elif lk == "referer":
            ref = v
        else:
            extra.append("%s: %s\r\n" % (k, v))
    args = ["-rw_timeout", "20000000"]
    if ua:
        args += ["-user_agent", ua]
    if ref:
        args += ["-referer", ref]
    if extra:
        args += ["-headers", "".join(extra)]
    return args


HLS_OPTS = ["-f", "hls", "-allowed_extensions", "ALL"]


HAVE_SUBFILTER = True


HAVE_FONTS = True


def check_fonts():
    """Roeghedstest: kan ffmpeg braende een lille tekst ind? (libass + fonte)"""
    global HAVE_FONTS
    try:
        import tempfile
        td = tempfile.mkdtemp(prefix="mb-font-")
        p = os.path.join(td, "t.srt")
        with open(p, "w", encoding="utf-8", newline="\n") as f:
            f.write("1\n00:00:00,000 --> 00:00:00,400\nprobe\n")
        # koer med cwd=td og et bart filnavn: Windows-stier (C:/...) kan ikke
        # escapes sikkert gennem subtitles-filterets dobbelte parsing.
        r = subprocess.run(
            [FFMPEG, "-v", "error", "-f", "lavfi", "-i", "color=c=black:s=320x240:d=0.5",
             "-vf", "subtitles=t.srt", "-frames:v", "2", "-f", "null", "-"],
            capture_output=True, text=True, timeout=20, cwd=td)
        HAVE_FONTS = r.returncode == 0
        if not HAVE_FONTS:
            log("ADVARSEL: ffmpeg kan ikke braende ind (libass/fonte): %s" % (r.stderr or "").strip()[-160:])
            log("ADVARSEL: installér fonte (Linux: sudo apt install fonts-dejavu-core libass9)")
        shutil.rmtree(td, ignore_errors=True)
    except Exception:
        HAVE_FONTS = True


def detect_hls_opts():
    """Finder ud af hvilke HLS-valg denne ffmpeg kender (saa filer med falske endelser virker)."""
    global HLS_OPTS, HAVE_SUBFILTER
    try:
        f = subprocess.run([FFMPEG, "-hide_banner", "-filters"], capture_output=True, text=True, timeout=10)
        HAVE_SUBFILTER = " subtitles " in (f.stdout or "")
        if not HAVE_SUBFILTER:
            log("ADVARSEL: ffmpeg mangler undertekst-filteret (libass) - undertekster paa TV virker ikke")
    except Exception:
        pass
    txt = ""
    try:
        r = subprocess.run([FFMPEG, "-hide_banner", "-h", "demuxer=hls"],
                           capture_output=True, text=True, timeout=10)
        txt = (r.stdout or "") + (r.stderr or "")
    except Exception:
        pass
    opts = ["-f", "hls"]          # tving HLS - ellers tror ffmpeg at .png er et billede
    if "allowed_extensions" in txt:
        opts += ["-allowed_extensions", "ALL"]
    if "extension_picky" in txt:
        opts += ["-extension_picky", "0"]
    HLS_OPTS = opts
    check_fonts()


def probe(url, headers, hls=False):
    cmd = [FFPROBE, "-v", "error"] + http_args(headers) + (HLS_OPTS if hls else []) + [
        "-show_programs", "-show_streams", "-show_format", "-of", "json", url]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=40)
    except subprocess.TimeoutExpired:
        return None, "ffprobe tog for lang tid (siden svarer ikke)"
    if r.returncode != 0:
        msg = (r.stderr or "").strip().splitlines()
        return None, (msg[-1] if msg else "ffprobe fejlede")
    try:
        return json.loads(r.stdout or "{}"), ""
    except ValueError:
        return None, "kunne ikke laese ffprobe-svar"


def upstream_check(url, headers):
    """Spoerger kilden direkte og beskriver svaret (til loggen)."""
    import urllib.request
    import urllib.error
    h = dict(headers)
    h["Range"] = "bytes=0-"
    h["Accept-Encoding"] = "identity"
    try:
        req = urllib.request.Request(url, headers=h)
        with urllib.request.urlopen(req, timeout=15) as r:
            code = r.status
            hd = r.headers
            final = r.geturl()
    except urllib.error.HTTPError as e:
        code, hd, final = e.code, e.headers, url
    except Exception as e:
        return "kilden svarede ikke: %s" % e
    parts = ["HTTP %s" % code]
    for k in ("Content-Type", "Content-Length", "Content-Range", "Accept-Ranges"):
        v = hd.get(k)
        if v:
            parts.append("%s=%s" % (k, v))
    if final != url:
        parts.append("omdirigeret til %s" % short(final))
    return ", ".join(parts)



def probe_source(url, headers):
    """Henter kilden UDEN Range og med/uden cookies, og beskriver MP4-kasserne (til loggen)."""
    import urllib.request
    out = []

    def grab(h, label):
        hh = dict(h)
        hh["Accept-Encoding"] = "identity"
        try:
            req = urllib.request.Request(url, headers=hh)
            with urllib.request.urlopen(req, timeout=15) as r:
                data = r.read(2000000)
                ct = r.headers.get("Content-Type", "?")
                cl = r.headers.get("Content-Length", "?")
        except Exception as e:
            out.append("%s: fejl %s" % (label, e))
            return
        boxes = []
        pos = 0
        while pos + 8 <= len(data) and len(boxes) < 12:
            size = int.from_bytes(data[pos:pos + 4], "big")
            typ = data[pos + 4:pos + 8].decode("latin-1")
            boxes.append("%s(%d)" % (typ, size))
            if size < 8:
                break
            pos += size
        head = data[:16].hex()
        out.append("%s: %d bytes laest, type=%s, laengde=%s, kasser=[%s], foerste bytes=%s" % (
            label, len(data), ct, cl, " ".join(boxes) or "ingen", head))

    grab(headers, "uden Range, alle headers")
    lite = {k: v for k, v in headers.items() if k.lower() not in ("cookie", "referer", "origin")}
    grab(lite, "uden Range, uden cookie/referer")
    return " | ".join(out)

def playlist_seconds(path):
    total = 0.0
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            for line in f:
                if line.startswith("#EXTINF:"):
                    try:
                        total += float(line[8:].split(",")[0])
                    except ValueError:
                        pass
    except OSError:
        pass
    return total


SUB_STYLE = ("FontSize=20,PrimaryColour=&H00FFFFFF&,OutlineColour=&H00000000&,"
             "BackColour=&H80000000&,BorderStyle=1,Outline=1.4,Shadow=0.6,MarginV=26,Alignment=2")


def esc_filter_path(path):
    return path.replace("\\", "\\\\").replace(":", "\\:").replace("'", "\\'")


def choose_streams(metas, prefer=("dan", "da", "eng", "en")):
    """Vaelger den bedste video (hoejst op til MAX_HEIGHT) og det bedste lydspor.
    Returnerer (video, (input_nr, stream)) eller None for hver."""
    best_v = None
    for k, meta in enumerate(metas):
        streams = meta.get("streams", [])
        vids = [st for st in streams if st.get("codec_type") == "video"
                and not st.get("disposition", {}).get("attached_pic", 0)]
        if not vids:
            continue

        def height(st):
            return int(st.get("height") or 0)
        ok = [st for st in vids if 0 < height(st) <= MAX_HEIGHT]
        v = max(ok, key=height) if ok else min(vids, key=height)
        best_v = (k, v)
        break

    def lang_rank(a):
        lang = ((a.get("tags") or {}).get("language") or "").lower()
        for i, l in enumerate(prefer):
            if lang.startswith(l):
                return i
        return 99

    best_a = None
    order = list(range(len(metas)))
    if best_v is not None:
        order.remove(best_v[0])
        order.insert(0, best_v[0])
    for k in order:
        meta = metas[k]
        auds = [st for st in meta.get("streams", []) if st.get("codec_type") == "audio"]
        if not auds:
            continue
        cand = auds
        if best_v is not None and k == best_v[0]:
            for prog in (meta.get("programs") or []):
                idxs = {st.get("index") for st in (prog.get("streams") or [])}
                if best_v[1].get("index") in idxs:
                    pa = [a for a in auds if a.get("index") in idxs]
                    if pa:
                        cand = pa
                    break
        best_a = (k, min(cand, key=lang_rank))
        break
    return best_v, best_a


def build_plan(vsel, asel, force, burn_path=None, atrim=0.0):
    """vsel/asel = (input_nr, stream) eller None. Returnerer (ffmpeg-valg, tekst)."""
    if vsel is None and asel is None:
        raise ValueError("ingen video eller lyd fundet i streamen")
    args = ["-sn", "-dn"]
    desc = []
    if vsel is not None:
        args += ["-map", "%d:%d" % (vsel[0], vsel[1]["index"])]
    if asel is not None:
        args += ["-map", "%d:%d" % (asel[0], asel[1]["index"])]

    if vsel is not None:
        v = vsel[1]
        vc = v.get("codec_name", "?")
        pix = v.get("pix_fmt", "")
        height = int(v.get("height") or 0)
        copy_ok = (vc == "h264" and pix in ("yuv420p", "yuvj420p", "")
                   and (height == 0 or height <= 2160) and not force and not burn_path)
        if copy_ok:
            args += ["-c:v", "copy"]
            desc.append("video %s kopieres" % vc)
        else:
            vf = "scale=w=-2:h='min(%d,ih)'" % MAX_HEIGHT
            if burn_path:
                # relativ sti til WORK: ffmpeg koeres med cwd=WORK, og Windows-stier
                # (C:/...) med kolon kan ikke escapes sikkert gennem subtitles-filteret.
                rel = os.path.relpath(burn_path, WORK).replace(os.sep, "/")
                vf += ",subtitles=filename='%s':force_style='%s'" % (esc_filter_path(rel), SUB_STYLE)
            if ENCODER == "vaapi":
                args = ["-vaapi_device", "/dev/dri/renderD128"] + args + [
                    "-vf", vf + ",format=nv12,hwupload", "-c:v", "h264_vaapi", "-qp", "22"]
            else:
                args += ["-vf", vf, "-c:v", "libx264", "-preset", "veryfast", "-crf", "21",
                         "-maxrate", "8M", "-bufsize", "16M", "-pix_fmt", "yuv420p",
                         "-profile:v", "high", "-level", "4.1",
                         "-g", "48", "-keyint_min", "48", "-sc_threshold", "0"]
            desc.append("video %s -> h264%s" % (vc, " med undertekster" if burn_path else ""))

    if asel is not None:
        a = asel[1]
        ac = a.get("codec_name", "?")
        prof = (a.get("profile") or "").upper()
        ch = int(a.get("channels") or 2)
        if atrim > 0.02:
            # lyden starter lidt foer billedet efter en spoling - klip den foerste bid af
            args += ["-af", "atrim=start=%.3f,asetpts=PTS-STARTPTS" % atrim,
                     "-c:a", "aac", "-b:a", "192k", "-ac", "2", "-ar", "48000"]
            desc.append("lyd %s -> aac (klippet %.1f sek)" % (ac, atrim))
        elif ac == "aac" and "HE" not in prof and ch <= 2 and not force:
            args += ["-c:a", "copy"]
            desc.append("lyd aac kopieres")
        else:
            args += ["-c:a", "aac", "-b:a", "192k", "-ac", "2", "-ar", "48000"]
            desc.append("lyd %s -> aac" % ac)
    else:
        desc.append("ingen lyd")
    return args, ", ".join(desc)


TS_RE = re.compile(r"(?:(\d+):)?(\d{1,2}):(\d\d)[,.](\d{1,3})\s*-->\s*(?:(\d+):)?(\d{1,2}):(\d\d)[,.](\d{1,3})")


MAP_RE = re.compile(
    r"X-TIMESTAMP-MAP:LOCAL:((?:(\d+):)?(\d{1,2}):(\d\d)[,.](\d{1,3})),MPEGTS:(\d+)")


def _secs(h, m, s, ms):
    return int(h or 0) * 3600 + int(m) * 60 + int(s) + int(ms.ljust(3, "0")) / 1000.0


def _fmt(x):
    x = max(0.0, x)
    ms = int(round(x * 1000))
    return "%02d:%02d:%02d,%03d" % (ms // 3600000, ms // 60000 % 60, ms // 1000 % 60, ms % 1000)


def _fmt_vtt(x):
    x = max(0.0, x)
    ms = int(round(x * 1000))
    return "%02d:%02d:%02d.%03d" % (ms // 3600000, ms // 60000 % 60, ms // 1000 % 60, ms % 1000)


def rebase_vtt_piece(txt):
    """WebVTT-stykker fra HLS hoerer ikke til media-tid. Hvert stykke saelger
    X-TIMESTAMP-MAP (LOCAL + MPEGTS); forskellen er stykkets forskydning.
    Ligger forskydningen over 0,05 sek skrives tiderne om til media-tid."""
    try:
        m = MAP_RE.search(txt or "")
        if not m:
            return txt
        local = _secs(*m.group(2, 3, 4, 5))
        ts = int(m.group(6))
        off = ts / 90000.0 - local
        if abs(off) <= 0.05:
            return txt
        def fix(mm):
            st = _secs(*mm.group(1, 2, 3, 4)) + off
            en = _secs(*mm.group(5, 6, 7, 8)) + off
            return "%s --> %s" % (_fmt_vtt(st), _fmt_vtt(en))
        return TS_RE.sub(fix, txt)
    except Exception:
        return txt


def parse_cues(text, shift):
    """Laeser SRT/WEBVTT i al almindelighed. Tider flyttes 'shift' sekunder tilbage
    (start-offset) og klippes sorteres. Returnerer liste af (start, slut, tekst)."""
    text = (text or "").replace("\r\n", "\n").replace("\r", "\n").lstrip("\ufeff")
    blocks = re.split(r"\n\s*\n", text)
    cues, seen = [], set()
    for b in blocks:
        lines = [ln for ln in b.split("\n") if ln.strip() != ""]
        k = next((i for i, ln in enumerate(lines) if TS_RE.search(ln)), None)
        if k is None:
            continue
        m = TS_RE.search(lines[k])
        st = _secs(*m.group(1, 2, 3, 4)) - shift
        en = _secs(*m.group(5, 6, 7, 8)) - shift
        body = [re.sub(r"<[^>]+>|\{\\[^}]*\}", "", ln) for ln in lines[k + 1:]]
        if en <= 0 or not any(x.strip() for x in body):
            continue
        sig = (round(st, 2), round(en, 2), "\n".join(body))
        if sig in seen:
            continue
        seen.add(sig)
        cues.append((st, en, "\n".join(body)))
    cues.sort(key=lambda c: c[0])
    return cues


def write_srt(cues, path):
    out = ["%d\n%s --> %s\n%s\n" % (i + 1, _fmt(a), _fmt(b), tx) for i, (a, b, tx) in enumerate(cues)]
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(out))


def write_vtt(cues, path):
    out = ["%s --> %s\n%s\n" % (_fmt_vtt(a), _fmt_vtt(b), tx) for (a, b, tx) in cues]
    with open(path, "w", encoding="utf-8") as f:
        f.write("WEBVTT\n\n" + "\n".join(out))


def write_srt_shifted(text, path, shift):
    """Skriver undertekster som SRT, flyttet 'shift' sekunder tilbage. Returnerer antal tekster."""
    cues = parse_cues(text, shift)
    write_srt(cues, path)
    return len(cues)


# ------------------------------------------------- oversaettelse til dansk

DA_MAX_CUES = 2000
DA_MAX_CHARS = 200

TRANSLATE_CACHE = {}
TR_LOCK = threading.Lock()
ARGOS_LOCK = threading.Lock()
ARGOS_STATE = {"ok": -1}          # -1 ubesoegt, 0 nej, 1 ja


def engine_available():
    """Hurtigt ja/nej uden at installere noget (bruges af /api/prepare-svaret)."""
    mode = os.environ.get("MB_TRANSLATE", "auto").strip().lower()
    if mode == "off":
        return False
    if mode == "test":
        return True
    if mode in ("auto", "argos"):
        try:
            from argostranslate.translate import get_translation  # type: ignore
        except Exception:
            get_translation = None
        if get_translation is not None:
            try:
                get_translation("en", "da")
                return True
            except Exception:
                # pakken er ikke installeret endnu; auto-installation kan goeres i baggrunden
                if mode == "auto" and os.environ.get("MB_ARGOS_AUTO", "1") == "1":
                    return True
                if mode == "argos":
                    return False
    if mode in ("auto", "libre") and os.environ.get("MB_LT_URL", "").strip():
        return True
    return False


def _engine_argos():
    """Argos Translate lokalt paa X280. Henter en->da pakken engang hvis noedvendigt."""
    try:
        from argostranslate import package as apkg        # type: ignore
        from argostranslate.translate import get_translation  # type: ignore
    except Exception:
        return None
    with ARGOS_LOCK:
        if ARGOS_STATE["ok"] == -1:
            ok = False
            try:
                get_translation("en", "da")
                ok = True
            except Exception:
                if os.environ.get("MB_ARGOS_AUTO", "1") == "1":
                    log("oversaettelse: henter argos-pakken en->da (engang, ca. 110 MB)...")
                    try:
                        apkg.update_package_index()
                        for pkg in apkg.get_available_packages():
                            if pkg.from_code == "en" and pkg.to_code == "da":
                                pkg.install()
                                break
                        get_translation("en", "da")
                        ok = True
                        log("oversaettelse: argos en->da klar")
                    except Exception as e:
                        log("oversaettelse: argos-pakken kunne ikke hentes (%s)" % e)
                else:
                    log("oversaettelse: argos en->da mangler - koeer den selv: "
                        "pip3 install argostranslate && argospm install translate-en_da")
            ARGOS_STATE["ok"] = 1 if ok else 0
    if ARGOS_STATE["ok"] != 1:
        return None

    def go(txt):
        try:
            out = get_translation("en", "da").translate(txt)
            return str(out) if out else txt
        except Exception:
            return txt
    try:
        probe_out = go("Hej med dig")
        if not probe_out:
            return None
    except Exception:
        return None
    return go


def _engine_libre():
    """LibreTranslate over HTTP (MB_LT_URL, fx din egen: http://127.0.0.1:5000)."""
    url = os.environ.get("MB_LT_URL", "").strip().rstrip("/")
    if not url:
        return None
    key = os.environ.get("MB_LT_KEY", "").strip()

    def go(txt):
        body = {"q": txt, "source": "auto", "target": "da", "format": "text"}
        if key:
            body["api_key"] = key
        req = urllib.request.Request(
            url + "/translate",
            data=json.dumps(body).encode("utf-8"),
            headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=25) as r:
            data = json.loads(r.read().decode("utf-8", "replace"))
            return data.get("translatedText") or txt
    try:
        if not go("Hej med dig"):
            return None
    except Exception as e:
        log("oversaettelse: LibreTranslate paa %s svarer ikke (%s)" % (url, e))
        return None
    return go


def translate_engine():
    """Vaelger oversaetter: argos lokalt foerst, ellers LibreTranslate. None = ingen."""
    mode = os.environ.get("MB_TRANSLATE", "auto").strip().lower()
    if mode == "off":
        return None
    if mode == "test":
        return lambda t: "DA " + t
    if mode in ("auto", "argos"):
        e = _engine_argos()
        if e is not None:
            return e
    if mode in ("auto", "libre"):
        e = _engine_libre()
        if e is not None:
            return e
    return None


def translate_texts(eng, texts):
    """Oversaetter en liste med cache, saatte genstart/spol ikke oversaetter forfra."""
    out = list(texts)
    todo = []
    with TR_LOCK:
        for i, t in enumerate(texts):
            h = hashlib.sha1(t.encode("utf-8")).hexdigest()
            if h in TRANSLATE_CACHE:
                out[i] = TRANSLATE_CACHE[h]
            else:
                todo.append((i, h))
    for i, h in todo:
        try:
            tr = eng(texts[i]) or texts[i]
        except Exception:
            tr = texts[i]
        out[i] = tr
        with TR_LOCK:
            if len(TRANSLATE_CACHE) > 20000:
                TRANSLATE_CACHE.pop(next(iter(TRANSLATE_CACHE)))
            TRANSLATE_CACHE[h] = tr
    return out


def start_da_track(s, cues, foreign):
    """Gaar forud for indbraending naar appen har bedt om dansk tekstspor (want_da).
    Skriver straks en pass-through subs_da.vtt (sa TV'et altid kan hente filen),
    og oversaetter i baggrunden hvis kilden ikke er dansk.
    Returnerer True naar tekstsporet har taget over (indbraending droppes)."""
    if not s.want_da or not cues or s.subtrack == "off":
        return False
    if foreign and not engine_available():
        log("[%s] ingen oversaetter foelbar (saet MB_LT_URL eller koeer: pip3 install argostranslate) - braender ind i stedet" % s.sid)
        return False
    s.da_total = min(len(cues), DA_MAX_CUES)
    if not foreign:
        s.da_done = s.da_total
        s.da_ready = True
        log("[%s] underteksterne er allerede danske - klaes direkte til TV'et" % s.sid)
    else:
        s.da_done = 0
        s.da_ready = False
        log("[%s] dansk tekstspor: oversaetter %d replikker i baggrunden" % (s.sid, s.da_total))
    s.subrev += 1
    dan = [(a, b, re.sub(r"\s+", " ", t)[:DA_MAX_CHARS]) for (a, b, t) in cues[:s.da_total]]
    if len(cues) > s.da_total:
        dan += [(a, b, re.sub(r"\s+", " ", t)[:DA_MAX_CHARS]) for (a, b, t) in cues[s.da_total:]]
    write_vtt(dan, os.path.join(s.dir, "subs_da.vtt"))
    log("[%s] tekstspor klar: /s/%s/subs_da.vtt (%d tekster)" % (s.sid, s.sid, len(dan)))
    if foreign:
        threading.Thread(target=_da_worker, args=(s, dan), daemon=True).start()
    return True


def _da_worker(s, cues):
    eng = translate_engine()
    if eng is None:
        log("[%s] ingen oversaetter paa maskinen - teksterne sendes uoversatte" % s.sid)
        s.da_ready = True
        return
    try:
        eng("Hej med dig")
    except Exception as e:
        log("[%s] oversaetter fejlede ved opstart (%s) - beholder originalen" % (s.sid, e))
        s.da_ready = True
        return
    txts = [c[2] for c in cues]
    out, chunk = [], 50
    try:
        for i in range(0, len(txts), chunk):
            if s.state not in ("starter", "konverterer", "faerdig"):
                return
            out.extend(translate_texts(eng, txts[i:i + chunk]))
            s.da_done = min(i + chunk, len(txts))
            if i == 0 or (i + chunk) % 200 == 0:
                log("[%s] oversat %d/%d replikker til dansk" % (s.sid, s.da_done, len(txts)))
        s.da_ready = True
        write_vtt([(a, b, t) for (a, b, _old), t in zip(cues, out)], os.path.join(s.dir, "subs_da.vtt"))
        s.subrev += 1
        log("[%s] danske tekster faerdige (%d replikker) - filen er opdateret" % (s.sid, len(cues)))
    except Exception as e:
        s.da_ready = True
        log("[%s] oversaettelsen stoppede (%s) - beholder sidste version" % (s.sid, e))


# ------------------------------------------------- stump-for-stump video (fMP4)

SEG_RE = re.compile(r"/seg-(\d+)(-[A-Za-z0-9_.\-]*?\.m4s)")


def fetch_bytes(url, headers, limit=None, timeout=20):
    import urllib.request
    h = dict(headers)
    h["Accept-Encoding"] = "identity"
    h.pop("Range", None)
    req = urllib.request.Request(url, headers=h)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read(limit) if limit else r.read()


def top_boxes(data):
    out, pos = [], 0
    while pos + 8 <= len(data) and len(out) < 20:
        size = int.from_bytes(data[pos:pos + 4], "big")
        typ = data[pos + 4:pos + 8].decode("latin-1")
        out.append(typ)
        if size < 8:
            break
        pos += size
    return out


def split_url(url):
    """(mappe, filnavn) for et link uden soegestreng."""
    path = url.split("?")[0]
    if "/" not in path.split("://", 1)[-1]:
        return path, ""
    folder, name = path.rsplit("/", 1)
    return folder, name


def segment_template(folder, init_name, trace):
    """Finder navnemoensteret paa stumperne: 1) appens spor, 2) startfilens navn, 3) standard."""
    pat = re.compile(re.escape(folder) + r"/seg-(\d+)(-[A-Za-z0-9_.\-]*?\.m4s)")
    for ln in (trace or "").splitlines():
        m = pat.search(ln)
        if m:
            return m.group(2), "appens spor"
    m = re.match(r"init(-[A-Za-z0-9_.\-]*?)\.mp4$", init_name or "", re.I)
    if m:
        return m.group(1) + ".m4s", "startfilens navn"
    return "-s1080p-v1-a1.m4s", "standardnavn"


def get_segment(url, headers, tries=4):
    """(data, 'ok'|'slut'|'fejl')"""
    import urllib.error
    last = ""
    for k in range(tries):
        try:
            return fetch_bytes(url, headers, timeout=25), "ok"
        except urllib.error.HTTPError as e:
            if e.code in (404, 410):
                return None, "slut"
            last = "HTTP %s" % e.code
        except Exception as e:
            last = str(e)
        time.sleep(1 + k)
    return last, "fejl"


def feed_segments(s, init, template, first_no, first_data, proc):
    """Traad: sender startfilen og alle stumper i raekkefoelge ind i ffmpeg."""
    n = 0
    try:
        proc.stdin.write(init)
        no, data = first_no, first_data
        t0 = time.time()
        while s.state in ("starter", "konverterer"):
            if data is None:
                data, how = get_segment(template % no, s.headers)
                if how == "slut":
                    break
                if how == "fejl":
                    log("[%s] stump %d kunne ikke hentes (%s) - stopper her" % (s.sid, no, data))
                    break
            proc.stdin.write(data)
            n += 1
            s.fed = n
            if n == 1 or n % 50 == 0:
                log("[%s] sendt %d stumper ind (%.0f sek)" % (s.sid, n, time.time() - t0))
            data = None
            no += 1
    except (BrokenPipeError, ValueError, OSError):
        pass
    finally:
        try:
            proc.stdin.close()
        except Exception:
            pass
        log("[%s] hentede i alt %d stumper fra siden" % (s.sid, n))


# ------------------------------------------------------------- stream-finder

def host_of(url):
    try:
        return urllib.parse.urlsplit(url).netloc.lower().split(":")[0]
    except Exception:
        return ""


def is_junk(url):
    """Reklamer, sporing og bot-tjek - aldrig en film."""
    h = host_of(url)
    if not h:
        return True
    if h.endswith((".rest", ".cfd")) or "wecollege" in h or "doubleclick" in h:
        return True
    if "googlesyndication" in h or "challenge" in h or "/cdn-cgi/" in url.lower():
        return True
    return False


def sniff(url, headers):
    """Kigger paa starten af et link og siger hvad det er."""
    try:
        data = fetch_bytes(url, headers, limit=300000, timeout=5)
    except urllib.error.HTTPError as e:
        return {"kind": "error", "err": "HTTP %s" % e.code}
    except Exception as e:
        return {"kind": "error", "err": str(e)[:80]}
    head = data[:2000].lstrip(b"\xef\xbb\xbf").lstrip()
    if head.startswith(b"#EXTM3U"):
        text = data.decode("utf-8", "replace")
        if "#EXT-X-STREAM-INF" in text:
            return {"kind": "master", "text": text}
        name = url.split("?")[0].rsplit("/", 1)[-1].lower()
        uris = [ln.strip().lower() for ln in text.splitlines() if ln.strip() and not ln.startswith("#")]
        if (uris and any(u.split("?")[0].endswith((".vtt", ".webvtt", ".srt")) for u in uris[:3])) \
                or "subtitle" in name:
            return {"kind": "mediasub", "text": text}
        return {"kind": "media", "text": text}
    if head.startswith(b"WEBVTT"):
        return {"kind": "vtt", "text": data.decode("utf-8", "replace")}
    boxes = top_boxes(data)
    if boxes and boxes[0] in ("ftyp", "styp", "moov", "moof", "mdat", "free", "sidx"):
        if "moov" in boxes and "mdat" not in boxes and "moof" not in boxes and len(data) < 300000:
            return {"kind": "mp4init", "data": data}
        if boxes[0] in ("styp", "moof"):
            return {"kind": "mp4frag"}
        return {"kind": "mp4"}
    if len(data) > 0 and data[:1] == b"\x47":
        return {"kind": "mp4"}      # rent transportstroem
    return {"kind": "other"}


def parse_attrs(s):
    out = {}
    for m in re.finditer(r'([A-Za-z0-9-]+)=("[^"]*"|[^,]*)', s):
        out[m.group(1).upper()] = m.group(2).strip().strip('"')
    return out


def parse_master(text, base):
    variants, groups, subs, pending = [], {}, [], None
    for ln in text.splitlines():
        ln = ln.strip()
        if ln.startswith("#EXT-X-MEDIA:"):
            a = parse_attrs(ln.split(":", 1)[1])
            item = {"lang": (a.get("LANGUAGE") or "").lower(), "name": a.get("NAME", ""),
                    "uri": urllib.parse.urljoin(base, a["URI"]) if a.get("URI") else "",
                    "default": a.get("DEFAULT", "") == "YES", "group": a.get("GROUP-ID", "")}
            typ = a.get("TYPE", "")
            if typ == "AUDIO":
                groups.setdefault(item["group"], []).append(item)
            elif typ == "SUBTITLES" and item["uri"]:
                subs.append(item)
        elif ln.startswith("#EXT-X-STREAM-INF:"):
            pending = parse_attrs(ln.split(":", 1)[1])
        elif ln and not ln.startswith("#") and pending is not None:
            res = pending.get("RESOLUTION", "")
            try:
                h = int(res.lower().split("x")[1]) if "x" in res.lower() else 0
            except ValueError:
                h = 0
            try:
                bw = int(pending.get("BANDWIDTH") or 0)
            except ValueError:
                bw = 0
            variants.append({"url": urllib.parse.urljoin(base, ln), "bw": bw, "h": h,
                             "audio": pending.get("AUDIO", "")})
            pending = None
    return variants, groups, subs


def lang_score(item, prefer=("dan", "da", "eng", "en")):
    lang = (item.get("lang") or "").lower()
    name = (item.get("name") or "").lower()
    for i, l in enumerate(prefer):
        if lang.startswith(l) or name.startswith({"dan": "danish", "da": "dansk", "eng": "english", "en": "english"}[l]):
            return i
    return 50 if item.get("default") else 60


def pick_variant(variants):
    ok = [v for v in variants if 0 < v["h"] <= MAX_HEIGHT]
    if ok:
        return max(ok, key=lambda v: (v["h"], v["bw"]))
    nores = [v for v in variants if v["h"] == 0]
    if nores:
        return max(nores, key=lambda v: v["bw"])
    return min(variants, key=lambda v: v["h"])


def hls_from_master(url, text):
    """Master-playliste -> (indgange, undertekstspor, tekst)."""
    variants, groups, subs = parse_master(text, url)
    if not variants:
        return [url], [], "master uden varianter - ffmpeg vaelger selv"
    v = pick_variant(variants)
    inputs = [v["url"]]
    how = "video %s" % (("%dp" % v["h"]) if v["h"] else "ukendt hoejde")
    items = [i for i in groups.get(v["audio"], []) if i["uri"]]
    if items:
        a = min(items, key=lang_score)
        inputs.append(a["uri"])
        how += ", lyd %s" % (a["lang"] or a["name"] or "?")
    return inputs, subs, how


def guess_masters(url):
    """Gaetter paa hvor hovedlisten ligger ud fra navnet paa en underliste."""
    base = url.split("?")[0]
    folder, name = base.rsplit("/", 1)
    m = re.search(r"\.m3u8(.*)$", name)
    tail = (".m3u8" + m.group(1)) if m else ".m3u8"
    out = []
    for stem in ("index", "master", "playlist", "main"):
        out.append("%s/%s%s" % (folder, stem, tail))
    if folder.count("/") > 3:
        up = folder.rsplit("/", 1)[0]
        for stem in ("index", "master"):
            out.append("%s/%s%s" % (up, stem, tail))
    return out


def init_for_segment(url, headers, trace, media):
    """Fra en stump (seg-N-...m4s) til startfilen i samme mappe."""
    path = url.split("?")[0]
    m = SEG_RE.search(path)
    folder = path[:m.start()]
    suffix = m.group(2)
    pool = list(media or []) + [ln.split(" ")[1] for ln in (trace or "").splitlines() if " " in ln]
    for u in pool:
        up = u.split("?")[0]
        if up.startswith(folder + "/") and "init" in up.rsplit("/", 1)[-1].lower():
            return u
    return "%s/init%s.mp4" % (folder, suffix[:-4])


def resolve(url, headers, trace, media):
    """Finder ud af hvad der egentlig skal hentes. Returnerer en ordbog med 'kind'."""
    cands = [url]
    for m in reversed(media or []):
        if m != url and m not in cands:
            cands.append(m)
    cands = [c for c in cands if not is_junk(c)][:14]
    notes = []
    cache = {}
    deadline = time.time() + 3.5          # telefonen venter kun kort - spild ikke tiden paa doede links

    def look(u):
        if u not in cache and u != url and time.time() > deadline:
            cache[u] = {"kind": "error", "err": "ikke tid"}
        if u not in cache:
            if SEG_RE.search(u.split("?")[0]):
                cache[u] = {"kind": "segment"}
            else:
                cache[u] = sniff(u, headers)
        return cache[u]

    def result(u, r):
        k = r["kind"]
        base = u.split("?")[0]
        if k == "master":
            inputs, subs, how = hls_from_master(u, r["text"])
            return {"kind": "hls", "inputs": inputs, "subs": subs, "key": base, "how": how, "src": u}
        if k == "segment":
            iu = init_for_segment(u, headers, trace, media)
            ir = sniff(iu, headers)
            if ir["kind"] != "mp4init":
                return None
            folder = base[:SEG_RE.search(base).start()]
            tmpl = folder + "/seg-%d" + SEG_RE.search(base).group(2)
            return {"kind": "segmented", "init": ir["data"], "template": tmpl, "key": folder,
                    "how": "stumper", "src": iu}
        if k == "mp4init":
            folder, name = split_url(u)
            if "." not in name:
                folder, name = base.rstrip("/"), ""
            suffix, how = segment_template(folder, name, trace)
            return {"kind": "segmented", "init": r["data"], "template": folder + "/seg-%d" + suffix,
                    "key": folder, "how": "stumper (%s)" % how, "src": u}
        if k == "media":
            # underliste: find hovedlisten (saa vi ogsaa faar lyden med)
            tries = [c for c in cands if c != u and host_of(c) == host_of(u)] + guess_masters(u)
            for c in tries[:16]:
                rr = look(c)
                if rr["kind"] == "master":
                    return result(c, rr)
            inputs = [u]
            folder = base.rsplit("/", 1)[0]
            for c in cands:
                cr = look(c)
                if c != u and cr["kind"] == "media" and c.split("?")[0].startswith(folder + "/") \
                        and "audio" in c.lower() and len(inputs) < 2:
                    inputs.append(c)
            return {"kind": "hls", "inputs": inputs, "subs": [], "key": base,
                    "how": "underliste uden hovedliste", "src": u}
        if k == "mp4":
            return {"kind": "file", "inputs": [u], "key": base, "how": "fil", "src": u}
        return None

    # 1) selve linket, 2) de andre fundne links - bedste foerst
    order = {"master": 0, "segment": 1, "mp4init": 1, "media": 2, "mp4": 3}
    found = []
    for i, c in enumerate(cands):
        r = look(c)
        k = r["kind"]
        if k in order:
            found.append((0 if i == 0 else 1, order[k], i, c, r))
        elif i == 0:
            notes.append("%s: %s" % (short(c), r.get("err") or k))
    # selve linket foerst hvis det er brugbart, ellers bedste af resten
    found.sort(key=lambda x: (x[0], x[1], x[2]))
    if found and found[0][4]["kind"] in ("segment", "mp4init"):
        same_host = [f for f in found if f[4]["kind"] == "master" and host_of(f[3]) == host_of(found[0][3])]
        if same_host:      # HLS-startfil: hovedlisten ligger ved siden af -> brug den (faar lyd med)
            found.remove(same_host[0])
            found.insert(0, same_host[0])
    for _, _, _, c, r in found:
        res = result(c, r)
        if res is not None:
            res["notes"] = notes
            return res
    return {"kind": "skip", "notes": notes}


# ------------------------------------------------------------- undertekster

def fetch_vtt(track, headers):
    """Henter et undertekstspor (liste af .vtt-stykker eller en enkelt fil) som een lang tekst.
    Stykker forskydes til media-tid via X-TIMESTAMP-MAP, saa spoling gaar rigtigt."""
    r = sniff(track["uri"], headers)
    if r["kind"] == "vtt":
        return rebase_vtt_piece(r["text"])
    if r["kind"] not in ("mediasub", "media"):
        return ""
    urls = [urllib.parse.urljoin(track["uri"], ln.strip()) for ln in r["text"].splitlines()
            if ln.strip() and not ln.startswith("#")][:3000]

    def one(u):
        try:
            return rebase_vtt_piece(fetch_bytes(u, headers, timeout=15).decode("utf-8", "replace"))
        except Exception:
            return ""
    from concurrent.futures import ThreadPoolExecutor
    with ThreadPoolExecutor(8) as ex:
        parts = list(ex.map(one, urls))
    ok = sum(1 for p in parts if p.strip())
    if ok == 0 and urls:
        log("undertekst-spor %s: %d stykker, 0 kunne hentes" % (track.get("lang") or track.get("name") or "?", len(urls)))
    elif ok < len(urls):
        log("undertekst-spor %s: %d af %d stykker hentet" % (track.get("lang") or track.get("name") or "?", ok, len(urls)))
    return "\n\n".join(parts)


def prepare_subs(s, res, tracks):
    """Lav en SRT-fil til indbraending + en VTT-fil til server. Returnerer sti eller None."""
    path = os.path.join(s.dir, "subs.srt")
    text, label, pick = "", "", None
    if s.subs:
        text, label = s.subs, "fra appen"
    elif tracks and s.subtrack != "off":
        pick = None
        if s.subtrack:
            pick = next((t for t in tracks if (t["lang"] or t["name"]).lower().startswith(s.subtrack.lower())), None)
            if pick is None:
                names = ", ".join((t["lang"] or t["name"] or "?") for t in tracks)
                log("[%s] oensket undertekstspor '%s' ikke fundet; tilgaengelige: %s" % (s.sid, s.subtrack, names))
        else:
            dan = [t for t in tracks if lang_score(t, ("dan", "da")) < 2]
            if dan:
                pick = dan[0]
            else:
                names = ", ".join((t["lang"] or t["name"] or "?") for t in tracks)
                log("[%s] intet dansk undertekstspor fundet; tilgaengelige: %s" % (s.sid, names))
        if pick is not None:
            text = fetch_vtt(pick, s.headers)
            label = "spor %s" % (pick["lang"] or pick["name"])
    if not text:
        log("[%s] ingen undertekster (kilde %s)" % (s.sid, s.subs and "appen" or (tracks and "spor" or "naevnt")))
        return None
    log("[%s] undertekster fundet (%s): %d tegn, foerste 120: %r" % (s.sid, label, len(text), text[:120]))
    cues = parse_cues(text, s.start)
    n = len(cues)
    if n == 0:
        head = text.replace("\n", " | ")[:400]
        log("[%s] 0 tekster laest af (%s). Raa start: %s" % (s.sid, label, head))
        s.sub_info = ""
        return None
    s.sub_info = label
    # Dansk tekstspor til TV'et (v2.3): tar over for indbraending naar appen bad om det.
    foreign = True
    if s.subs:
        foreign = False          # appens egne tekster er i forvejen paa dens sprog (dansk)
    elif pick is not None:
        lg = (pick.get("lang") or "").lower()
        nm = (pick.get("name") or "").lower()
        foreign = lg not in ("da", "dan") and "dansk" not in nm
    if start_da_track(s, cues, foreign):
        return None
    if not HAVE_SUBFILTER:
        log("[%s] springer undertekster over (ffmpeg kan ikke braende dem ind)" % s.sid)
        return None
    if not HAVE_FONTS:
        log("[%s] ADVARSEL: fonte mangler, indbraending kan give fejl" % s.sid)
    write_srt(cues, path)
    write_vtt(cues, os.path.join(s.dir, "subs.vtt"))
    log("[%s] undertekster (%s): %d tekster, flyttet %.0f sek, sidste slutter %.1f sek" % (
        s.sid, label, n, s.start, cues[-1][1] if cues else 0))
    return path


# ------------------------------------------------------------- koersel

def ffmpeg_out(s):
    return ["-max_muxing_queue_size", "2048",
            "-f", "hls", "-hls_time", "4", "-hls_list_size", "0",
            "-hls_playlist_type", "event", "-hls_flags", "independent_segments+temp_file",
            "-hls_segment_type", "mpegts",
            "-hls_segment_filename", os.path.join(s.dir, "seg%05d.ts"),
            s.playlist]


def finish(s, rc):
    if s.state == "konverterer":
        got = playlist_seconds(s.playlist)
        if rc == 0 and got > 0:
            s.state = "faerdig"
            s.output_seconds = got
            log("[%s] faerdig: %d stykker = %d min %02d sek video" % (
                s.sid, s.segments(), got // 60, got % 60))
        else:
            s.state = "fejl"
            s.error = s.stderr[-1] if s.stderr else "ffmpeg stoppede (kode %s)" % rc
            log("[%s] ffmpeg-FEJL: %s" % (s.sid, s.error))
        for line in list(s.stderr)[-5:]:
            log("[%s] ffmpeg: %s" % (s.sid, line))


def pump_stderr(s):
    for raw in s.proc.stderr:
        line = raw.decode("utf-8", "replace").strip() if isinstance(raw, bytes) else raw.strip()
        if line:
            s.stderr.append(line)


def abs_tag(line, base):
    return re.sub(r'URI="([^"]*)"', lambda m: 'URI="%s"' % urllib.parse.urljoin(base, m.group(1)), line)


def trim_playlist(text, base, start):
    """Skaerer en HLS-underliste, saa den starter ved den stump hvor 'start' sekunder ligger.
    (ffmpegs egen spolning i fMP4-HLS giver aedelagt billede, derfor goer vi det selv.)
    Returnerer (ny tekst, rigtig starttid) eller (None, 0)."""
    seq0, version, target, endlist = 0, "", "", False
    cur_map = cur_key = None
    pend, kept = [], []
    cum, skipped, aligned, dur = 0.0, 0, None, 0.0
    for ln in text.splitlines():
        s = ln.strip()
        if not s:
            continue
        if s.startswith("#EXT-X-MEDIA-SEQUENCE:"):
            try:
                seq0 = int(s.split(":", 1)[1])
            except ValueError:
                seq0 = 0
        elif s.startswith("#EXT-X-TARGETDURATION"):
            target = s
        elif s.startswith("#EXT-X-VERSION"):
            version = s
        elif s.startswith("#EXT-X-ENDLIST"):
            endlist = True
        elif s.startswith("#EXT-X-MAP:"):
            cur_map = abs_tag(s, base)
            if aligned is not None:
                kept.append(cur_map)
        elif s.startswith("#EXT-X-KEY:"):
            cur_key = abs_tag(s, base)
            if aligned is not None:
                kept.append(cur_key)
        elif s.startswith("#EXTINF:"):
            try:
                dur = float(s.split(":", 1)[1].split(",")[0])
            except ValueError:
                dur = 0.0
            pend.append(s)
        elif s.startswith(("#EXT-X-BYTERANGE", "#EXT-X-DISCONTINUITY")):
            pend.append(s)
        elif s.startswith("#"):
            continue
        else:
            end = cum + dur
            if aligned is None and end <= start + 0.001:
                skipped += 1
                cum, pend = end, []
                continue
            if aligned is None:
                aligned = cum
                kept += [x for x in (cur_map, cur_key) if x]
            kept += pend + [urllib.parse.urljoin(base, s)]
            pend, cum = [], end
    if aligned is None or not kept:
        return None, 0.0
    head = ["#EXTM3U", version or "#EXT-X-VERSION:7", target or "#EXT-X-TARGETDURATION:10",
            "#EXT-X-MEDIA-SEQUENCE:%d" % (seq0 + skipped)]
    return "\n".join(head + kept + (["#EXT-X-ENDLIST"] if endlist else [])) + "\n", aligned


def fetch_text(url, headers):
    return fetch_bytes(url, headers, timeout=25).decode("utf-8", "replace")


def run_inputs(s, res):
    """HLS-lister eller filer: probe, vaelg spor, konverter."""
    inputs = res["inputs"]
    is_hls = res["kind"] == "hls"
    log("[%s] kilde (%s): %s" % (s.sid, res.get("how", ""), "  +  ".join(short(u) for u in inputs)))
    metas, ok_inputs = [], []
    for i, u in enumerate(inputs):
        meta, err = probe(u, s.headers, hls=is_hls)
        if meta is None:
            log("[%s] kan ikke aabne %s: %s" % (s.sid, short(u), err))
            if i == 0:
                s.state, s.error = "fejl", err
                return
            continue
        metas.append(meta)
        ok_inputs.append(u)
    vsel, asel = choose_streams(metas)
    if vsel is None:
        s.state, s.error = "fejl", "ingen video i streamen"
        log("[%s] FEJL: %s" % (s.sid, s.error))
        return
    fmt0 = metas[vsel[0]].get("format", {})
    try:
        dur = float(fmt0.get("duration") or 0)
    except ValueError:
        dur = 0.0
    s.duration = dur
    s.source_seconds = dur
    if 0 < dur < 90:
        log("[%s] ADVARSEL: kilden er kun %d sek - maaske en reklame" % (s.sid, dur))
    used = sorted({vsel[0]} | ({asel[0]} if asel else set()))
    urls = {k: ok_inputs[k] for k in used}
    offsets = {}
    if s.start > 0 and is_hls:
        want, vk = s.start, vsel[0]
        done = {}
        order = [vk] + [k for k in used if k != vk]
        try:
            for k in order:
                txt, al = trim_playlist(fetch_text(ok_inputs[k], s.headers), ok_inputs[k], want)
                if txt is None:
                    raise ValueError("start efter filmens slut")
                with open(os.path.join(s.dir, "in%d.m3u8" % k), "w", encoding="utf-8") as f:
                    f.write(txt)
                done[k] = al
                if k == vk:
                    want = al
                else:
                    offsets[k] = al - done[vk]
            for k in used:
                urls[k] = "http://127.0.0.1:%d/s/%s/in%d.m3u8" % (PORT, s.sid, k)
            s.start = done[vk]
        except Exception as e:
            log("[%s] kunne ikke spole (%s) - starter forfra" % (s.sid, e))
            s.start, urls, offsets = 0.0, {k: ok_inputs[k] for k in used}, {}
    elif s.start > 0:
        pass          # almindelig fil: ffmpegs -ss virker fint
    burn = prepare_subs(s, res, res.get("subs") or [])
    try:
        atrim = max(0.0, -offsets.get(asel[0], 0.0)) if asel else 0.0
        plan_args, s.plan = build_plan(vsel, asel, s.force, burn, atrim)
    except ValueError as e:
        s.state, s.error = "fejl", str(e)
        return
    remap = {old: new for new, old in enumerate(used)}
    fixed, i = [], 0
    while i < len(plan_args):
        if plan_args[i] == "-map":
            a, b = plan_args[i + 1].split(":")
            fixed += ["-map", "%d:%s" % (remap[int(a)], b)]
            i += 2
        else:
            fixed.append(plan_args[i])
            i += 1
    log("[%s] plan: %s, start %.0f sek, laengde %s" % (
        s.sid, s.plan, s.start, ("%d min" % (dur // 60)) if dur else "ukendt"))
    cmd = [FFMPEG, "-hide_banner", "-nostdin", "-loglevel", "warning"]
    for k in used:
        cmd += ["-reconnect", "1", "-reconnect_streamed", "1", "-reconnect_delay_max", "5"]
        cmd += http_args(s.headers) + (HLS_OPTS if is_hls else [])
        if s.start > 0 and not is_hls:
            cmd += ["-ss", "%.2f" % s.start]
        cmd += ["-i", urls[k]]
    cmd += fixed + ffmpeg_out(s)
    try:
        s.proc = subprocess.Popen(cmd, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                                  stderr=subprocess.PIPE, cwd=WORK)
    except OSError as e:
        s.state, s.error = "fejl", "kunne ikke starte ffmpeg: %s" % e
        return
    s.state = "konverterer"
    pump_stderr(s)
    finish(s, s.proc.wait())


def seg_duration(path):
    """Hvor mange sekunder video der er i en lille fil (til at regne stump-nummer ud fra tid)."""
    try:
        r = subprocess.run([FFMPEG, "-hide_banner", "-nostdin", "-i", path, "-c", "copy", "-f", "null", "-"],
                           capture_output=True, text=True, timeout=30)
    except Exception:
        return 0.0
    ts = re.findall(r"time=(\d+):(\d\d):(\d\d(?:\.\d+)?)", (r.stderr or ""))
    if not ts:
        return 0.0
    h, m, sec = ts[-1]
    return int(h) * 3600 + int(m) * 60 + float(sec)


def first_time(path):
    """Tidspunkt (sek) for foerste billede/lyd i en lille mp4-fil, regnet fra filmens start."""
    try:
        r = subprocess.run([FFPROBE, "-v", "error", "-show_entries", "packet=pts_time,dts_time",
                            "-read_intervals", "%+#8", "-of", "csv=p=0", path],
                           capture_output=True, text=True, timeout=30)
    except Exception:
        return None
    vals = []
    for ln in (r.stdout or "").splitlines():
        for x in ln.split(","):
            try:
                vals.append(float(x))
            except ValueError:
                pass
    return min(vals) if vals else None


def run_segmented(s, res):
    init, template = res["init"], res["template"]
    s.segmented = True
    log("[%s] siden leverer video i stumper (startfil %d bytes) - henter dem selv" % (s.sid, len(init)))
    first_no, first = None, None
    for no in (1, 0):
        data, how = get_segment(template % no, s.headers, tries=2)
        if how == "ok":
            first_no, first = no, data
            break
    if first is None:
        s.state, s.error = "fejl", "kunne ikke hente den foerste stump (%s)" % (template % 1)[-60:]
        log("[%s] FEJL: %s" % (s.sid, s.error))
        return
    probe_file = os.path.join(s.dir, "probe.mp4")
    with open(probe_file, "wb") as f:
        f.write(init + first)
    meta, err = probe(probe_file, {})
    if meta is None:
        s.state, s.error = "fejl", "kunne ikke laese stumperne: %s" % err
        log("[%s] FEJL: %s" % (s.sid, s.error))
        return
    segdur = SEGDUR.get(res["key"]) or seg_duration(probe_file) or 6.0
    SEGDUR[res["key"]] = segdur
    try:
        os.remove(probe_file)
    except OSError:
        pass
    try:
        dur = float((meta.get("format") or {}).get("duration") or 0)
    except ValueError:
        dur = 0.0
    s.duration = dur if dur > 600 else 0.0
    s.source_seconds = dur
    # spring ind i filmen: find stumpen hvor starttiden ligger (og regn den rigtige starttid ud)
    t_first = 0.0
    if s.start > 0:
        idx, tries, best = first_no + int(s.start / segdur), 0, None
        while tries < 4:
            tries += 1
            data, how = get_segment(template % idx, s.headers, tries=3)
            if how != "ok":
                break
            tmp = os.path.join(s.dir, "seek.mp4")
            with open(tmp, "wb") as f:
                f.write(init + data)
            tt = first_time(tmp)
            try:
                os.remove(tmp)
            except OSError:
                pass
            if tt is None:
                break
            best = (idx, data, tt)
            if tt <= s.start + 0.05 and s.start - tt < segdur * 1.2:
                break
            # skaev: ret stump-nummeret ud fra hvor langt vi er fra maalet
            per = tt / max(1, idx - first_no) if idx > first_no and tt > 0 else segdur
            idx = max(first_no, idx + int(round((s.start - tt) / max(per, 0.5))))
            if tt > s.start:
                idx = min(idx, best[0] - 1)
        if best is not None and best[2] <= s.start + 0.5:
            first_no, first, t_first = best
            s.start = t_first
        else:
            log("[%s] kunne ikke springe til %.0f sek - starter forfra" % (s.sid, s.start))
            s.start = 0.0
    vsel, asel = choose_streams([meta])
    burn = prepare_subs(s, res, [])
    try:
        plan_args, s.plan = build_plan(vsel, asel, s.force, burn)
    except ValueError as e:
        s.state, s.error = "fejl", str(e)
        log("[%s] FEJL: %s" % (s.sid, e))
        return
    log("[%s] film: %s, stump = %.1f sek, start %.0f sek, plan: %s" % (
        s.sid, ("%d min" % (dur // 60)) if dur > 600 else "ukendt laengde", segdur, s.start, s.plan))
    cmd = [FFMPEG, "-hide_banner", "-nostdin", "-loglevel", "warning"]
    if s.start > 0:
        cmd += ["-itsoffset", "%.3f" % (-t_first)]
    cmd += ["-i", "pipe:0"] + plan_args + ffmpeg_out(s)
    try:
        s.proc = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.DEVNULL,
                                  stderr=subprocess.PIPE, cwd=WORK)
    except OSError as e:
        s.state, s.error = "fejl", "kunne ikke starte ffmpeg: %s" % e
        log("[%s] %s" % (s.sid, s.error))
        return
    s.state = "konverterer"
    threading.Thread(target=feed_segments, args=(s, init, template, first_no, first, s.proc),
                     daemon=True).start()
    pump_stderr(s)
    finish(s, s.proc.wait())


SEGDUR = {}


def run_session(s, res):
    try:
        if res["kind"] == "segmented":
            run_segmented(s, res)
        else:
            run_inputs(s, res)
    except Exception as e:
        s.state, s.error = "fejl", "intern fejl: %s" % e
        log("[%s] INTERN FEJL: %r" % (s.sid, e))


def active_session():
    with SESS_LOCK:
        live = [x for x in SESSIONS.values() if x.state in ("starter", "konverterer", "faerdig")]
    return max(live, key=lambda x: x.created) if live else None


def start_session(url, headers, title="", force=False, trace="", media=None, start=0.0,
                  subs="", subtrack="", restart=False, want_da=False):
    """Returnerer (session, samme_som_foer, fejltekst)."""
    hdrs = {k: v for k, v in (headers or {}).items() if v and k.lower() not in SKIP_HEADERS}
    res = resolve(url, hdrs, trace, media)
    if res["kind"] == "skip":
        act = active_session()
        if act is not None and not restart:
            act.last = time.time()
            act.want_da = bool(want_da)
            log("[%s] intet nyt at hente i dette link - beholder den der koerer" % act.sid)
            return act, True, ""
        return None, False, "fandt ingen video i dette link (%s)" % ("; ".join(res.get("notes") or ["ukendt"]))
    key = res["key"]
    old = find_session(key)
    if old is not None and not force:
        same = True
        old.want_da = bool(want_da)
        if restart:
            same = abs(old.req_start - float(start or 0)) < 3 and old.subs == (subs or "") \
                and old.subtrack == (subtrack or "")
        if same:
            old.last = time.time()
            log("[%s] samme film (%s) - genbruger igangvaerende stream" % (old.sid, res.get("how", "")))
            return old, True, ""
    s = Session(url, hdrs, title, force, start, subs)
    s.req_start = float(start or 0)
    s.subtrack = subtrack or ""
    s.want_da = bool(want_da)
    s.key = key
    s.trace = trace or ""
    s.tracks = [{"lang": t["lang"], "name": t["name"]} for t in (res.get("subs") or [])]
    with SESS_LOCK:
        for other in list(SESSIONS.values()):
            if other.alive():
                log("[%s] stopper (ny stream startet)" % other.sid)
                other.stop("afloest")
        SESSIONS[s.sid] = s
    threading.Thread(target=run_session, args=(s, res), daemon=True).start()
    return s, False, ""


def janitor():
    while True:
        time.sleep(60)
        now = time.time()
        with SESS_LOCK:
            for sid, s in list(SESSIONS.items()):
                if now - s.last > IDLE_SECONDS:
                    log("[%s] ryddet op (ikke brugt i %d min)" % (sid, IDLE_SECONDS // 60))
                    s.stop("ryddet")
                    del SESSIONS[sid]


# ------------------------------------------------------------- chromecast

CAST = {"devices": {}, "time": 0, "browser": None, "current": None, "error": ""}
CAST_LOCK = threading.Lock()

try:
    import pychromecast  # type: ignore
    HAVE_PYCC = True
except Exception:  # pragma: no cover
    HAVE_PYCC = False


def discover(refresh=False):
    if not HAVE_PYCC:
        CAST["error"] = "pychromecast er ikke installeret"
        return []
    with CAST_LOCK:
        if refresh or time.time() - CAST["time"] > 300 or not CAST["devices"]:
            try:
                if CAST["browser"] is not None:
                    try:
                        CAST["browser"].stop_discovery()
                    except Exception:
                        pass
                casts, browser = pychromecast.get_chromecasts(timeout=6)
                CAST["browser"] = browser
                CAST["devices"] = {str(c.uuid): c for c in casts}
                CAST["time"] = time.time()
                CAST["error"] = ""
                log("fandt %d TV/Chromecast: %s" % (
                    len(casts), ", ".join(c.cast_info.friendly_name for c in casts)))
            except Exception as e:
                CAST["error"] = str(e)
                log("TV-soegning fejlede: %s" % e)
        return [{"id": k, "name": c.cast_info.friendly_name,
                 "model": c.cast_info.model_name}
                for k, c in CAST["devices"].items()]


def local_ip_towards(host):
    try:
        u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        u.connect((host, 9))
        ip = u.getsockname()[0]
        u.close()
        return ip
    except OSError:
        return "127.0.0.1"


def cast_to_tv(device_id, play_url, title):
    with CAST_LOCK:
        cc = CAST["devices"].get(device_id)
    if cc is None:
        raise RuntimeError("TV'et blev ikke fundet - tryk 'Find TV' igen")
    cc.wait(timeout=10)
    mc = cc.media_controller
    mc.play_media(play_url, "application/x-mpegURL", title=title or "MovieBench",
                  stream_type="BUFFERED")
    mc.block_until_active(timeout=15)
    CAST["current"] = cc
    log("sendt til %s" % cc.cast_info.friendly_name)


def control(action):
    cc = CAST.get("current")
    if cc is None:
        raise RuntimeError("intet TV er i gang fra denne side")
    mc = cc.media_controller
    if action == "pause":
        mc.pause()
    elif action == "play":
        mc.play()
    elif action == "stop":
        cc.quit_app()
    else:
        raise RuntimeError("ukendt handling")


# ---------------------------------------------------------- UDP discovery

def discovery_responder():
    try:
        u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        u.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        u.bind(("0.0.0.0", DISC_PORT))
    except OSError as e:
        log("UDP-opdagelse kunne ikke starte: %s" % e)
        return
    log("lytter efter telefoner paa UDP %d" % DISC_PORT)
    while True:
        try:
            data, addr = u.recvfrom(256)
            if data.strip().startswith(b"MOVIEBRIDGE?"):
                u.sendto(("MOVIEBRIDGE %d %s" % (PORT, VERSION)).encode(), addr)
        except OSError:
            time.sleep(1)


# ------------------------------------------------------------------- HTTP

def page():
    return PAGE_HTML.replace("{{VERSION}}", VERSION)


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "MovieBridge/" + VERSION

    def log_message(self, fmt, *args):
        pass

    # --- helpers
    def cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, HEAD, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Access-Control-Expose-Headers",
                         "Content-Length, Content-Range, Content-Type, Accept-Ranges")

    def send(self, code, body, ctype="text/plain; charset=utf-8", extra=None):
        if isinstance(body, str):
            body = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-cache")
        self.cors()
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.send_header("Connection", "close")
        self.end_headers()
        self.close_connection = True
        if self.command != "HEAD":
            try:
                self.wfile.write(body)
            except (BrokenPipeError, ConnectionResetError):
                pass

    def json_out(self, obj, code=200):
        self.send(code, json.dumps(obj, ensure_ascii=False), "application/json; charset=utf-8")

    def body_json(self):
        n = int(self.headers.get("Content-Length") or 0)
        if n <= 0 or n > 1_000_000:
            return {}
        try:
            return json.loads(self.rfile.read(n).decode("utf-8"))
        except ValueError:
            return {}

    def own_ip(self):
        try:
            return self.connection.getsockname()[0]
        except OSError:
            return "127.0.0.1"

    # --- verbs
    def do_OPTIONS(self):
        self.send_response(204)
        self.cors()
        self.send_header("Content-Length", "0")
        self.send_header("Connection", "close")
        self.end_headers()
        self.close_connection = True

    def do_HEAD(self):
        self.do_GET()

    def do_GET(self):
        path = urllib.parse.urlsplit(self.path).path
        q = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
        if path == "/":
            return self.send(200, page(), "text/html; charset=utf-8")
        if path == "/health":
            return self.send(200, "ok")
        if path == "/log":
            with LOG_LOCK:
                txt = "\n".join(LOG)
            return self.send(200, "MovieBridge %s\n\n%s\n" % (VERSION, txt))
        if path == "/api/status":
            with SESS_LOCK:
                ss = [s.info() for s in sorted(SESSIONS.values(), key=lambda x: -x.created)]
            with LOG_LOCK:
                lg = list(LOG)[-40:]
            return self.json_out({"version": VERSION, "sessions": ss, "log": lg,
                                  "cast": HAVE_PYCC, "cast_error": CAST["error"]})
        if path == "/api/progress":
            sid = (q.get("id") or [""])[0]
            with SESS_LOCK:
                s = SESSIONS.get(sid)
            if s is None:
                return self.json_out({"ok": False, "error": "findes ikke"})
            i = s.info()
            i["ok"] = True
            return self.json_out(i)
        if path == "/api/devices":
            return self.json_out({"devices": discover(refresh="refresh" in q),
                                  "error": CAST["error"]})
        if path.startswith("/s/"):
            return self.serve_session(path)
        return self.send(404, "ikke fundet")

    def do_POST(self):
        path = urllib.parse.urlsplit(self.path).path
        data = self.body_json()
        if path == "/api/prepare":
            url = (data.get("url") or "").strip()
            if not url.startswith(("http://", "https://")):
                return self.json_out({"ok": False, "error": "ugyldigt link"}, 400)
            tr = (data.get("trace") or "").strip()
            media = [m for m in (data.get("media") or []) if isinstance(m, str)][-30:]
            try:
                start = float(data.get("start") or 0)
            except (TypeError, ValueError):
                start = 0.0
            if tr:
                log("telefonens seneste forespoergsler (nyeste nederst):")
                for ln in tr.splitlines()[-30:]:
                    log("   app: %s" % ln[:230])
            s, same, err = start_session(url, data.get("headers") or {}, data.get("title") or "",
                                         data.get("force"), tr, media, start,
                                         data.get("subs") or "", data.get("subtrack") or "",
                                         bool(data.get("restart")), bool(data.get("want_da")))
            if s is None:
                log("FEJL: %s" % err)
                return self.json_out({"ok": False, "error": err})
            play = "http://%s:%d/s/%s/index.m3u8" % (self.own_ip(), PORT, s.sid)
            log("[%s] telefon %s bad om stream%s -> %s" % (
                s.sid, self.client_address[0], " (samme som foer)" if same else "", play))
            off = s.subtrack == "off" and not (s.subs or "")
            sub_url = ""
            if s.want_da and not off:
                sub_url = "http://%s:%d/s/%s/subs_da.vtt?v=%d" % (
                    self.own_ip(), PORT, s.sid, s.subrev)
            return self.json_out({"ok": True, "id": s.sid, "play_url": play, "same": same,
                                  "content_type": "application/x-mpegURL",
                                  "start": s.start, "duration": s.duration,
                                  "tracks": s.tracks, "sub": s.sub_info,
                                  "sub_url": sub_url,
                                  "subs_url": "http://%s:%d/s/%s/subs.vtt" % (
                                      self.own_ip(), PORT, s.sid)})
        if path == "/api/cast":
            url = (data.get("url") or "").strip()
            if not url.startswith(("http://", "https://")):
                return self.json_out({"ok": False, "error": "skriv et gyldigt link"}, 400)
            headers = {}
            if data.get("referer"):
                headers["Referer"] = data["referer"].strip()
            if data.get("cookie"):
                headers["Cookie"] = data["cookie"].strip()
            if data.get("user_agent"):
                headers["User-Agent"] = data["user_agent"].strip()
            else:
                headers["User-Agent"] = ("Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 "
                                         "(KHTML, like Gecko) Chrome/131.0 Mobile Safari/537.36")
            s, _same, err = start_session(url, headers, data.get("title") or "", data.get("force"))
            if s is None:
                return self.json_out({"ok": False, "error": err})
            dev = data.get("device") or ""
            if not dev:
                return self.json_out({"ok": True, "id": s.sid,
                                      "note": "stream klar - vaelg et TV for at sende den"})
            with CAST_LOCK:
                cc = CAST["devices"].get(dev)
            host = cc.cast_info.host if cc is not None else "8.8.8.8"
            play = "http://%s:%d/s/%s/index.m3u8" % (local_ip_towards(host), PORT, s.sid)
            # vent til de foerste stykker er klar, saa TV'et ikke giver op
            t0 = time.time()
            while time.time() - t0 < 40 and s.segments() < 2 and s.state in ("starter", "konverterer"):
                time.sleep(0.5)
            if s.state == "fejl":
                return self.json_out({"ok": False, "error": "streamen kunne ikke hentes: " + s.error})
            try:
                cast_to_tv(dev, play, s.title)
            except Exception as e:
                return self.json_out({"ok": False, "error": str(e)})
            return self.json_out({"ok": True, "id": s.sid})
        if path == "/api/control":
            try:
                control(data.get("action", ""))
                return self.json_out({"ok": True})
            except Exception as e:
                return self.json_out({"ok": False, "error": str(e)})
        if path == "/api/stop":
            sid = data.get("id", "")
            with SESS_LOCK:
                s = SESSIONS.pop(sid, None)
            if s:
                s.stop()
                log("[%s] stoppet fra web-siden" % sid)
            return self.json_out({"ok": True})
        return self.json_out({"ok": False, "error": "ukendt"}, 404)

    # --- HLS files
    def serve_session(self, path):
        parts = path.strip("/").split("/")
        if len(parts) != 3:
            return self.send(404, "ikke fundet")
        _, sid, name = parts
        with SESS_LOCK:
            s = SESSIONS.get(sid)
        if s is None:
            return self.send(404, "stream findes ikke (mere)")
        s.last = time.time()
        if name in ("subs.vtt", "subs_da.vtt"):
            fp = os.path.join(s.dir, name)
            try:
                with open(fp, "rb") as f:
                    data = f.read()
            except OSError:
                return self.send(404, "undertekster ikke klar (endnu)")
            if self.command == "GET":
                s.subs_served += 1
                if s.subs_served == 1 or s.subs_served % 10 == 0:
                    log("[%s] undertekster (%s) hentet af %s (%d KB)" % (
                        sid, name, self.client_address[0], len(data) // 1024))
            return self.send(200, data, "text/vtt; charset=utf-8")
        if name == "index.m3u8":
            t0 = time.time()
            while time.time() - t0 < 40 and s.segments() < 8 and s.state in ("starter", "konverterer"):
                time.sleep(0.3)
            if s.segments() == 0:
                log("[%s] TV bad om stream, men intet klar (%s %s)" % (sid, s.state, s.error))
                return self.send(503 if s.state != "fejl" else 502,
                                 "ikke klar: %s %s" % (s.state, s.error))
            try:
                with open(s.playlist, "rb") as f:
                    data = f.read()
            except OSError:
                return self.send(503, "ikke klar")
            if self.command == "GET":
                log("[%s] %s henter playlisten (%d stykker klar)" % (
                    sid, self.client_address[0], s.segments()))
            return self.send(200, data, "application/vnd.apple.mpegurl")
        if re.match(r"^in\d\.m3u8$", name):
            try:
                with open(os.path.join(s.dir, name), "rb") as f:
                    return self.send(200, f.read(), "application/vnd.apple.mpegurl")
            except OSError:
                return self.send(404, "ikke fundet")
        if not name.startswith("seg") or not name.endswith(".ts") or "/" in name or ".." in name:
            return self.send(404, "ikke fundet")
        fp = os.path.join(s.dir, name)
        try:
            with open(fp, "rb") as f:
                data = f.read()
        except OSError:
            log("[%s] TV bad om %s, som ikke findes" % (sid, name))
            return self.send(404, "segment ikke fundet")
        if self.command == "GET":
            s.seg_hits += 1
            if s.seg_hits == 1 or s.seg_hits % 25 == 0:
                log("[%s] %s henter %s (%d. stykke hentet, %d KB)" % (
                    sid, self.client_address[0], name, s.seg_hits, len(data) // 1024))
        return self.send(200, data, "video/mp2t")


PAGE_HTML = r"""<!doctype html>
<html lang="da"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>MovieBridge</title>
<style>
:root{--bg:#0b0d12;--card:#141821;--line:#232a36;--txt:#e8ecf3;--dim:#8b95a7;--acc:#6ea8fe;--ok:#3ecf8e;--bad:#ff6b6b}
*{box-sizing:border-box}body{margin:0;font:15px/1.5 system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:var(--bg);color:var(--txt)}
main{max-width:760px;margin:0 auto;padding:24px 16px 60px}
h1{font-size:22px;margin:0 0 4px}p.sub{color:var(--dim);margin:0 0 20px}
.card{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px;margin-bottom:16px}
label{display:block;font-size:13px;color:var(--dim);margin:10px 0 4px}
input,select{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--line);background:#0f131a;color:var(--txt);font:inherit}
.row{display:flex;gap:8px;flex-wrap:wrap;margin-top:14px}
button{padding:10px 16px;border-radius:10px;border:1px solid var(--line);background:#1b2130;color:var(--txt);font:inherit;cursor:pointer}
button.pri{background:var(--acc);border-color:var(--acc);color:#08101f;font-weight:600}
button:disabled{opacity:.5;cursor:wait}
.chk{display:flex;gap:8px;align-items:center;margin-top:10px;color:var(--dim);font-size:14px}.chk input{width:auto}
#msg{margin-top:12px;min-height:22px}.ok{color:var(--ok)}.bad{color:var(--bad)}
details summary{cursor:pointer;color:var(--dim);margin-top:10px}
table{width:100%;border-collapse:collapse;font-size:14px}td{padding:8px 4px;border-top:1px solid var(--line);vertical-align:top}
td small{color:var(--dim)}pre{white-space:pre-wrap;font-size:12px;color:var(--dim);margin:0;max-height:260px;overflow:auto}
</style></head><body><main>
<h1>MovieBridge</h1><p class="sub">Oversætter streams til din Chromecast og dit Android TV · v{{VERSION}}</p>

<div class="card">
<label for="url">Link til video eller stream</label>
<input id="url" placeholder="https://…/video.mp4 eller …/playlist.m3u8">
<label for="tv">TV / Chromecast</label>
<div class="row" style="margin-top:0"><select id="tv" style="flex:1"></select><button id="find">Find TV</button></div>
<details><summary>Ekstra (hvis siden kræver det)</summary>
<label for="ref">Referer (siden linket kommer fra)</label><input id="ref" placeholder="https://siden.dk/">
<label for="ck">Cookie</label><input id="ck" placeholder="navn=værdi; navn2=værdi2">
<div class="chk"><input type="checkbox" id="force"><label for="force" style="margin:0">Tving fuld omkodning (hvis billede eller lyd driller)</label></div>
</details>
<div class="row"><button class="pri" id="go">Send til TV</button><button data-a="pause">Pause</button><button data-a="play">Fortsæt</button><button data-a="stop">Stop TV</button></div>
<div id="msg"></div>
</div>

<div class="card"><b>Aktive streams</b><table id="ss"></table></div>
<div class="card"><b>Log</b><pre id="log"></pre></div>
</main>
<script>
const $=s=>document.querySelector(s);
function msg(t,ok){const m=$('#msg');m.textContent=t;m.className=ok===undefined?'':(ok?'ok':'bad')}
async function api(p,b){const r=await fetch(p,b?{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(b)}:{});return r.json()}
async function devices(refresh){const sel=$('#tv');sel.innerHTML='<option value="">Søger…</option>';
 try{const d=await api('/api/devices'+(refresh?'?refresh=1':''));sel.innerHTML='';
  if(!d.devices.length){sel.innerHTML='<option value="">Ingen TV fundet</option>';if(d.error)msg(d.error,false)}
  d.devices.forEach(x=>{const o=document.createElement('option');o.value=x.id;o.textContent=x.name+(x.model?' ('+x.model+')':'');sel.appendChild(o)});
  const last=localStorage.getItem('mb_tv');if(last&&[...sel.options].some(o=>o.value===last))sel.value=last;
 }catch(e){sel.innerHTML='<option value="">Fejl</option>'}}
$('#find').onclick=()=>devices(true);
$('#tv').onchange=()=>{try{localStorage.setItem('mb_tv',$('#tv').value)}catch(e){}};
$('#go').onclick=async()=>{const b=$('#go');const url=$('#url').value.trim();if(!url){msg('Indsæt et link først',false);return}
 b.disabled=true;msg('Henter og gør klar … (kan tage op til 40 sek.)');
 try{const r=await api('/api/cast',{url,device:$('#tv').value,referer:$('#ref').value,cookie:$('#ck').value,force:$('#force').checked});
  msg(r.ok?(r.note||'Kører på TV’et ✓'):r.error,r.ok)}catch(e){msg('Ingen forbindelse til X280',false)}
 b.disabled=false;refresh()};
document.querySelectorAll('[data-a]').forEach(b=>b.onclick=async()=>{const r=await api('/api/control',{action:b.dataset.a});msg(r.ok?'OK':r.error,r.ok)});
async function stop(id){await api('/api/stop',{id});refresh()}
const ST={starter:'Starter…',konverterer:'Omdanner…',faerdig:'Klar',fejl:'Fejl',stoppet:'Stoppet',afloest:'Afløst af ny stream',ryddet:'Ryddet op'};
function esc(s){return String(s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]))}
async function refresh(){try{const s=await api('/api/status');
 $('#ss').innerHTML=s.sessions.length?s.sessions.map(x=>`<tr><td>${esc(x.title||x.url)}<br><small>${esc(ST[x.state]||x.state)} · ${x.segments} stykker · ${esc(x.plan||'')}${x.error?' · '+esc(x.error):''}</small></td><td style="text-align:right"><button onclick="stop('${x.id}')">Stop</button></td></tr>`).join(''):'<tr><td><small>Ingen lige nu</small></td></tr>';
 $('#log').textContent=s.log.slice().reverse().join('\n')}catch(e){}}
devices(false);refresh();setInterval(refresh,3000);
</script></body></html>"""


def selftest():
    """Koerer hele kaeden paa denne maskine med falske sider, der ligner de rigtige."""
    import tempfile
    import http.server
    global WORK
    WORK = tempfile.mkdtemp(prefix="mb-selftest-")
    detect_hls_opts()
    # enhedstest: WebVTT-tidsforskydning (X-TIMESTAMP-MAP) og delt parsing
    mt = rebase_vtt_piece("WEBVTT\nX-TIMESTAMP-MAP:LOCAL:00:00:10.000,MPEGTS:1800000\n\n"
                          "00:00:05.000 --> 00:00:08.000\nTest\n")
    ok_map = "00:00:15.000 --> 00:00:18.000" in mt
    nc = parse_cues(mt, 0)
    ok_map = ok_map and len(nc) == 1 and abs(nc[0][0] - 15.0) < 0.02
    print("SELVTEST %s: vtt-tidsforskydning (X-TIMESTAMP-MAP)" % ("OK  " if ok_map else "FEJL"))
    if not ok_map:
        bad_map = 1
    else:
        bad_map = 0
    media = os.path.join(WORK, "src.mp4")
    r = subprocess.run([FFMPEG, "-v", "error", "-y", "-f", "lavfi", "-i",
                        "testsrc=size=1280x720:rate=25", "-f", "lavfi", "-i",
                        "sine=frequency=440:sample_rate=48000", "-t", "24",
                        "-c:v", "libx264", "-pix_fmt", "yuv420p", "-g", "25", "-c:a", "aac",
                        "-movflags", "frag_keyframe+empty_moov+default_base_moof",
                        "-frag_duration", "4000000", media], capture_output=True, text=True)
    if r.returncode != 0:
        print("SELVTEST FEJL: ffmpeg kunne ikke lave testfil: %s" % r.stderr.strip()[-300:])
        return 1
    # HLS-testsite: video og lyd hver for sig, falske .png-endelser, undertekster.
    # ffmpeg 9 paa Windows skriver ikke fMP4-init-filen med HLS-muxeren, saa stykkerne
    # bygges med -movflags og skilles ad i bokse (samme teknik som stump-siden).
    hd = os.path.join(WORK, "hls")
    os.makedirs(hd)

    def split_fmp4(path):
        d = open(path, "rb").read()
        boxes, pos = [], 0
        while pos < len(d):
            sz = int.from_bytes(d[pos:pos + 4], "big")
            boxes.append((d[pos + 4:pos + 8], d[pos:pos + sz]))
            pos += sz
        init = b"".join(b for ty, b in boxes if ty in (b"ftyp", b"moov"))
        frs, cur = [], b""
        for ty, b in boxes:
            if ty == b"moof":
                cur = b
            elif ty == b"mdat":
                frs.append(cur + b)
                cur = b""
        return init, frs

    def frag_dur(init, fr):
        tmp = os.path.join(hd, "probe_frag.mp4")
        with open(tmp, "wb") as f:
            f.write(init + fr)
        r = subprocess.run([FFPROBE, "-v", "error", "-show_entries", "packet=duration_time",
                            "-of", "csv=p=0", tmp], capture_output=True, text=True)
        os.remove(tmp)
        s = 0.0
        for x in (r.stdout or "").splitlines():
            x = x.strip()
            if x:
                s += float(x)
        return s

    def build_hls(src_args, stem):
        full = os.path.join(hd, stem + "_full.mp4")
        r = subprocess.run([FFMPEG, "-v", "error", "-y"] + src_args +
                           ["-movflags", "frag_keyframe+empty_moov+default_base_moof",
                            "-frag_duration", "4000000", full], capture_output=True, text=True)
        if r.returncode != 0:
            raise RuntimeError("ffmpeg %s: %s" % (stem, (r.stderr or "").strip()[-200:]))
        init, frs = split_fmp4(full)
        if not frs:
            raise RuntimeError("ingen stykker i %s" % stem)
        os.remove(full)
        durs = [frag_dur(init, fr) for fr in frs]
        with open(os.path.join(hd, "%s_init.mp4" % stem), "wb") as f:
            f.write(init)
        for i, fr in enumerate(frs):
            with open(os.path.join(hd, "%s_%03d.m4s" % (stem, i)), "wb") as f:
                f.write(fr)
        target = int(max(durs) + 0.999)
        pl = ["#EXTM3U", "#EXT-X-VERSION:7", "#EXT-X-TARGETDURATION:%d" % target,
              "#EXT-X-MEDIA-SEQUENCE:0", "#EXT-X-PLAYLIST-TYPE:VOD",
              '#EXT-X-MAP:URI="%s_init.mp4"' % stem]
        for i, du in enumerate(durs):
            pl += ["#EXTINF:%.3f," % du, "%s_%03d.m4s" % (stem, i)]
        pl.append("#EXT-X-ENDLIST")
        with open(os.path.join(hd, "%s.m3u8" % stem), "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(pl) + "\n")
        return sum(durs)

    tot = build_hls(["-f", "lavfi", "-i", "testsrc=size=1280x720:rate=25", "-t", "24",
                     "-c:v", "libx264", "-pix_fmt", "yuv420p", "-g", "100", "-an"], "video")
    tot += build_hls(["-f", "lavfi", "-i", "sine=frequency=440:sample_rate=48000", "-t", "24",
                      "-c:a", "aac"], "audio")
    if tot < 40:
        print("SELVTEST FEJL: HLS-testfiler blev kun %d sek" % tot)
        return 1
    master = ('#EXTM3U\n#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="a",NAME="English",LANGUAGE="en",DEFAULT=YES,'
              'URI="audio.m3u8.png"\n#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="s",NAME="Dansk",LANGUAGE="da",'
              'URI="subtitles_da.m3u8.png"\n#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="s",NAME="English",'
              'LANGUAGE="en",URI="subtitles_en.m3u8.png"\n'
              '#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,AUDIO="a",'
              'SUBTITLES="s"\nvideo.m3u8.png\n')
    subpl = "#EXTM3U\n#EXT-X-TARGETDURATION:30\n#EXTINF:30,\nsub0.vtt.png\n#EXT-X-ENDLIST\n"
    vtt = "WEBVTT\n\n" + "".join("00:00:%02d.000 --> 00:00:%02d.900\nHej %d\n\n" % (i, i, i) for i in range(1, 23, 3))
    init, frs = split_fmp4(media)

    class H(http.server.BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def log_message(self, *a):
            pass

        def do_GET(self):
            body, code = b"", 404
            if self.headers.get("Referer") != "https://movy.example/":
                body, code = b"nej", 403
            elif self.path.startswith("/h/") and self.path.endswith(".png"):
                n = self.path[3:-4]
                if n == "index.m3u8":
                    body, code = master.encode(), 200
                elif n == "subtitles_da.m3u8":
                    body, code = subpl.encode(), 200
                elif n == "subtitles_en.m3u8":
                    body, code = subpl.encode(), 200
                elif n == "sub0.vtt":
                    body, code = vtt.encode(), 200
                elif os.path.exists(os.path.join(hd, n)):
                    body, code = open(os.path.join(hd, n), "rb").read(), 200
                    if n.endswith(".m3u8"):
                        tx = body.decode()
                        tx = re.sub(r'URI="([^"]+)"', lambda m: 'URI="%s.png"' % m.group(1), tx)
                        tx = "\n".join((ln + ".png") if ln and not ln.startswith("#") else ln
                                       for ln in tx.replace("\r\n", "\n").split("\n"))
                        body = tx.encode()
            elif self.path in ("/vd/TOK/init-s1080p-v1-a1.mp4", "/vd/TOK2"):
                body, code = init, (206 if self.headers.get("Range") else 200)
            elif self.path.startswith("/vd/TOK/seg-") and self.path.endswith("-s1080p-v1-a1.m4s"):
                n = int(self.path.split("seg-")[1].split("-")[0])
                if 1 <= n <= len(frs):
                    body, code = frs[n - 1], 200
            elif self.path.startswith("/vd/TOK2/seg-") and self.path.endswith("-v9.m4s"):
                n = int(self.path.split("seg-")[1].split("-")[0])
                if 1 <= n <= len(frs):
                    body, code = frs[n - 1], 200
            self.send_response(code)
            self.send_header("Content-Length", str(len(body)))
            if code == 206:
                self.send_header("Content-Range", "bytes 0-%d/%d" % (len(body) - 1, len(body)))
            self.end_headers()
            self.wfile.write(body)

    class Quiet(ThreadingHTTPServer):
        daemon_threads = True

        def handle_error(self, request, client_address):
            pass

    global PORT
    srv = Quiet(("127.0.0.1", 0), H)
    threading.Thread(target=srv.serve_forever, daemon=True).start()
    port = srv.server_address[1]
    mine = Quiet(("127.0.0.1", 0), Handler)       # bridgen selv (bruges til spolede lister)
    PORT = mine.server_address[1]
    threading.Thread(target=mine.serve_forever, daemon=True).start()
    hdr = {"Referer": "https://movy.example/", "User-Agent": "selvtest"}
    os.environ["MB_TRANSLATE"] = "test"     # sikkert mock-oversaetter: "DA " + tekst
    base = "http://127.0.0.1:%d" % port
    cases = [
        ("stump-side: startfil med filendelse", base + "/vd/TOK/init-s1080p-v1-a1.mp4", "", [], 0, "", 20, False, False),
        ("stump-side: link uden filendelse + appens spor", base + "/vd/TOK2",
         "GET %s/vd/TOK2/seg-5-v9.m4s" % base, [], 0, "", 20, False, False),
        ("HLS: video+lyd hver for sig, falske .png-endelser", base + "/h/video.m3u8.png", "", [], 0, "off", 20, True, False),
        ("HLS: spol til 9 sek + undertekster paa billedet", base + "/h/index.m3u8.png", "", [], 9, "da", 10, True, False),
        ("HLS: appen sender undertekst-listen (skal bruge hovedlisten)", base + "/h/subtitles_da.m3u8.png", "",
         [base + "/h/index.m3u8.png"], 0, "off", 20, True, False),
        ("HLS: engelsk undertekstspor oversaettes til dansk tekstspor", base + "/h/index.m3u8.png", "",
         [], 0, "en", 10, True, True),
    ]
    bad = 0
    for label, url, tr, med, start, sub, need, want_audio, want_da in cases:
        s, same, err = start_session(url, hdr, "", False, tr, med, start, "", sub,
                                     bool(start), want_da)
        if s is None:
            print("SELVTEST FEJL: %s: %s" % (label, err))
            bad += 1
            continue
        t0 = time.time()
        while time.time() - t0 < 120 and s.state in ("starter", "konverterer"):
            time.sleep(0.5)
        has_audio = False
        try:
            meta, _ = probe(s.playlist, {})
            has_audio = any(x.get("codec_type") == "audio" for x in (meta or {}).get("streams", []))
        except Exception:
            pass
        ok = s.state == "faerdig" and s.output_seconds >= need and (has_audio or not want_audio)
        if start:
            ok = ok and s.start >= 4 and s.output_seconds <= 24 - s.start + 3
        print("SELVTEST %s: %s (%d sek video, lyd=%s, start %d)" % (
            "OK  " if ok else "FEJL", label, s.output_seconds, "ja" if has_audio else "nej", s.start))
        if not ok:
            bad += 1
            print("   tilstand=%s fejl=%s" % (s.state, s.error))
            for line in list(s.stderr)[-4:]:
                print("   ffmpeg: %s" % line)
        if sub == "da":
            vp = os.path.join(s.dir, "subs.vtt")
            try:
                with open(vp, encoding="utf-8") as f:
                    vt = f.read()
                okv = vt.startswith("WEBVTT") and " --> " in vt
            except OSError:
                vt, okv = "", False
            print("SELVTEST %s: subs.vtt skrevet (%d tegn)" % ("OK  " if okv else "FEJL", len(vt)))
            if not okv:
                bad += 1
            else:
                import urllib.request
                try:
                    with urllib.request.urlopen("http://127.0.0.1:%d/s/%s/subs.vtt" % (PORT, s.sid), timeout=10) as rr:
                        okh = rr.status == 200 and rr.read(16).decode("utf-8", "replace").startswith("WEBVTT")
                except Exception:
                    okh = False
                print("SELVTEST %s: subs.vtt hentet over HTTP" % ("OK  " if okh else "FEJL"))
                if not okh:
                    bad += 1
        if want_da:
            t1 = time.time()
            while time.time() - t1 < 20 and not s.da_ready:
                time.sleep(0.2)
            okd = s.da_ready and s.da_done == s.da_total and s.da_total > 0
            print("SELVTEST %s: dansk tekstspor oversat (%d/%d replikker)" % (
                "OK  " if okd else "FEJL", s.da_done, s.da_total))
            if not okd:
                bad += 1
            else:
                import urllib.request
                try:
                    u = "http://127.0.0.1:%d/s/%s/subs_da.vtt?v=%d" % (PORT, s.sid, s.subrev)
                    with urllib.request.urlopen(u, timeout=10) as rr:
                        dtext = rr.read().decode("utf-8", "replace")
                    okd2 = dtext.startswith("WEBVTT") and "DA Hej" in dtext and " --> " in dtext
                except Exception:
                    dtext, okd2 = "", False
                print("SELVTEST %s: subs_da.vtt hentet over HTTP, oversat (%d tegn)" % (
                    "OK  " if okd2 else "FEJL", len(dtext)))
                if not okd2:
                    bad += 1
    ok_dup = False
    act = active_session()
    if act is not None:
        s2, same2, _ = start_session(base + "/h/index.m3u8.png", hdr, "", False, "", [], 0, "", "", False)
        ok_dup = s2 is not None
    print("SELVTEST %s: kan starte en ny stream bagefter" % ("OK  " if ok_dup else "FEJL"))
    bad += 0 if ok_dup else 1
    for x in list(SESSIONS.values()):
        x.stop()
    shutil.rmtree(WORK, ignore_errors=True)
    return 1 if (bad + bad_map) else 0


def main():
    if "--selftest" in sys.argv:
        return selftest()
    os.makedirs(WORK, exist_ok=True)
    for name in os.listdir(WORK):
        shutil.rmtree(os.path.join(WORK, name), ignore_errors=True)
    if not shutil.which(FFMPEG) and not os.path.exists(FFMPEG):
        log("ADVARSEL: ffmpeg blev ikke fundet - installer det (sudo apt install ffmpeg)")
    detect_hls_opts()
    threading.Thread(target=janitor, daemon=True).start()
    threading.Thread(target=discovery_responder, daemon=True).start()
    if HAVE_PYCC:
        threading.Thread(target=discover, daemon=True).start()
    srv = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    srv.daemon_threads = True
    log("MovieBridge %s klar paa http://<X280-IP>:%d  (encoder: %s)" % (VERSION, PORT, ENCODER))
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        with SESS_LOCK:
            for s in SESSIONS.values():
                s.stop()


if __name__ == "__main__":
    sys.exit(main())
