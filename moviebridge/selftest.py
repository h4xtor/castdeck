#!/usr/bin/env python3
"""Selvtest for MovieBridge.

Bygger to falske kilder (type A: fMP4-HLS, type B: TS med .png-forklædte
segmenter, separat lyd og WebVTT), starter broen på en tilfældig port og
kører hele kæden igennem: forberedelse, playliste, segmenter, deduplikering,
genstart med starttid, undertekster, Range, opdagelse og stop.

Kør:  python3 selftest.py
Alt foregår i en midlertidig mappe og ryddes op bagefter.
"""

from __future__ import annotations

import json
import os
import shutil
import socket
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
FFMPEG = os.environ.get("MB_FFMPEG", "ffmpeg")
FFPROBE = os.environ.get("MB_FFPROBE", "ffprobe")

RESULTS: list[tuple[str, bool, str]] = []


def check(name: str, ok: bool, detail: str = "") -> None:
    RESULTS.append((name, ok, detail))
    print(("  OK   " if ok else "  FEJL ") + name + (f"  [{detail}]" if detail and not ok else ""))


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, **kwargs)


def ensure_font(root: str) -> str:
    """libass skal bruge en rigtig skrifttype. Findes der ingen, hentes DejaVu."""
    candidates = [os.environ.get("MB_SUBS_FONTS_DIR", "")]
    for folder in ("/usr/share/fonts", "/usr/local/share/fonts", os.path.expanduser("~/.fonts")):
        if folder and os.path.isdir(folder):
            for base, _dirs, files in os.walk(folder):
                if any(name.lower().endswith((".ttf", ".otf")) for name in files):
                    candidates.append(base)
                    break
    for folder in candidates:
        if folder and os.path.isdir(folder):
            return folder
    fonts = os.path.join(root, "fonts")
    os.makedirs(fonts, exist_ok=True)
    target = os.path.join(fonts, "OpenSans.ttf")
    url = ("https://raw.githubusercontent.com/google/fonts/main/ofl/opensans/"
           "OpenSans%5Bwdth,wght%5D.ttf")
    try:
        with urllib.request.urlopen(url, timeout=90) as resp, open(target, "wb") as fh:
            fh.write(resp.read())
    except (urllib.error.URLError, OSError):
        return ""
    return fonts if os.path.getsize(target) > 50_000 else ""


def font_family(folder: str) -> str:
    """Kun den hentede skrifttype kræver et eksplicit navn; systemfonte findes selv."""
    if folder and os.path.basename(folder) == "fonts" and os.listdir(folder):
        return "Open Sans"
    return ""


def free_port() -> int:
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        return sock.getsockname()[1]


def wait_http(url: str, timeout: float = 40) -> bool:
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            with urllib.request.urlopen(url, timeout=2) as resp:
                if resp.status == 200:
                    return True
        except (urllib.error.URLError, OSError):
            time.sleep(0.3)
    return False


def get(url: str, headers: dict[str, str] | None = None) -> tuple[int, bytes, dict[str, str]]:
    req = urllib.request.Request(url, headers=headers or {})
    try:
        with urllib.request.urlopen(req, timeout=90) as resp:
            return resp.status, resp.read(), dict(resp.headers)
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read(), dict(exc.headers)


def post_json(url: str, payload: dict) -> tuple[int, dict]:
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            return resp.status, json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", "replace")
        try:
            return exc.code, json.loads(body)
        except json.JSONDecodeError:
            return exc.code, {"error": body}


# --------------------------------------------------------------------------
# Falske kilder
# --------------------------------------------------------------------------

def build_sources(root: str) -> dict[str, str]:
    base = os.path.join(root, "base.mp4")
    run([FFMPEG, "-hide_banner", "-loglevel", "error", "-y",
         "-f", "lavfi", "-i", "testsrc2=size=320x180:rate=25:duration=36",
         "-f", "lavfi", "-i", "sine=frequency=440:sample_rate=48000:duration=36",
         "-c:v", "libx264", "-preset", "ultrafast", "-pix_fmt", "yuv420p",
         "-c:a", "aac", "-b:a", "96k", "-shortest", base], check=True)

    a_dir = os.path.join(root, "A")
    os.makedirs(a_dir, exist_ok=True)
    run([FFMPEG, "-hide_banner", "-loglevel", "error", "-y", "-i", base,
         "-c", "copy", "-f", "hls", "-hls_time", "4", "-hls_playlist_type", "vod",
         "-hls_segment_type", "fmp4", "-hls_fmp4_init_filename", "init.mp4",
         "-hls_segment_filename", os.path.join(a_dir, "seg-%d.m4s"),
         os.path.join(a_dir, "index.m3u8")], check=True)

    b_dir = os.path.join(root, "B")
    os.makedirs(b_dir, exist_ok=True)
    run([FFMPEG, "-hide_banner", "-loglevel", "error", "-y", "-i", base, "-an",
         "-c:v", "copy", "-f", "hls", "-hls_time", "4", "-hls_playlist_type", "vod",
         "-hls_segment_filename", os.path.join(b_dir, "v-%d.png"),
         os.path.join(b_dir, "v.m3u8")], check=True)
    run([FFMPEG, "-hide_banner", "-loglevel", "error", "-y", "-i", base, "-vn",
         "-c:a", "copy", "-f", "hls", "-hls_time", "4", "-hls_playlist_type", "vod",
         "-hls_segment_filename", os.path.join(b_dir, "a-%d.png"),
         os.path.join(b_dir, "a.m3u8")], check=True)
    with open(os.path.join(b_dir, "master.m3u8"), "w", encoding="utf-8") as fh:
        fh.write("#EXTM3U\n#EXT-X-VERSION:3\n"
                 '#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud",NAME="Dansk",DEFAULT=YES,URI="a.m3u8"\n'
                 '#EXT-X-STREAM-INF:BANDWIDTH=900000,RESOLUTION=320x180,CODECS="avc1.4d401e,mp4a.40.2",AUDIO="aud"\n'
                 "v.m3u8\n")
    with open(os.path.join(b_dir, "subs.vtt"), "w", encoding="utf-8") as fh:
        fh.write("WEBVTT\n\n00:00:01.000 --> 00:00:08.000\nFørste replik\n\n"
                 "00:00:09.000 --> 00:00:16.000\nAnden replik\n")

    return {
        "A": f"http://127.0.0.1:{SRC_PORT}/A/index.m3u8",
        "B": f"http://127.0.0.1:{SRC_PORT}/B/master.m3u8",
        "dir": root,
    }


def probe_streams(path: str) -> list[str]:
    result = run([FFPROBE, "-v", "error", "-show_entries", "stream=codec_type,codec_name",
                  "-of", "csv=p=0", path])
    return [line.strip() for line in result.stdout.splitlines() if line.strip()]


def ssim(first: str, second: str) -> float | None:
    result = run([FFMPEG, "-hide_banner", "-nostdin", "-i", first, "-i", second,
                  "-lavfi", "[0:v][1:v]ssim", "-f", "null", "-"], timeout=120)
    for line in result.stderr.splitlines():
        if "All:" in line:
            try:
                return float(line.split("All:")[1].split()[0])
            except (IndexError, ValueError):
                return None
    return None


def main() -> int:
    global SRC_PORT
    if shutil.which(FFMPEG) is None or shutil.which(FFPROBE) is None:
        print("ffmpeg/ffprobe mangler")
        return 2

    root = tempfile.mkdtemp(prefix="mbselftest-")
    src_proc = bridge_proc = None
    SRC_PORT = free_port()
    port = free_port()
    discovery = free_port()
    cache = os.path.join(root, "cache")
    print(f"selvtest: bygger kilder i {root}")
    try:
        sources = build_sources(root)
        src_proc = subprocess.Popen([sys.executable, "-m", "http.server", str(SRC_PORT),
                                     "--bind", "127.0.0.1", "--directory", root],
                                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if not wait_http(f"http://127.0.0.1:{SRC_PORT}/B/master.m3u8", 20):
            print("kunne ikke starte den falske kilde")
            return 2

        env = dict(os.environ)
        fonts = ensure_font(root)
        env.update({
            "MB_PORT": str(port), "MB_DISCOVERY_PORT": str(discovery), "MB_CACHE": cache,
            "MB_HLS_TIME": "2", "MB_PREBUFFER_SEGMENTS": "3", "MB_PREBUFFER_TIMEOUT": "60",
            "MB_FFMPEG": FFMPEG, "MB_FFPROBE": FFPROBE,
            "MB_SUBS_FONTS_DIR": fonts,
            "MB_SUBS_FONT_NAME": font_family(fonts),
        })
        log_path = os.path.join(root, "bridge.out")
        bridge_proc = subprocess.Popen([sys.executable, os.path.join(HERE, "moviebridge.py")],
                                       env=env, stdout=open(log_path, "wb"),
                                       stderr=subprocess.STDOUT)
        base = f"http://127.0.0.1:{port}"
        if not wait_http(base + "/healthz", 30):
            print("broen startede ikke. Log:")
            print(open(log_path, "r", errors="replace").read()[-3000:])
            return 2

        check("skrifttype til undertekster fundet", bool(fonts), fonts or "ingen")
        status, body = post_json(base + "/api/prepare", {"url": sources["A"], "start": 0})
        check("type A: /api/prepare svarer ok", status == 200 and body.get("ok") is True,
              f"{status} {body}")
        sid_a = body.get("sid", "")
        playlist_url = body.get("url", "")
        code, data, _ = get(playlist_url)
        text = data.decode("utf-8", "replace")
        check("type A: playliste leveres", code == 200 and "#EXTM3U" in text, f"{code}")
        segments = [line for line in text.splitlines() if line and not line.startswith("#")]
        check("type A: playlisten har segmenter", len(segments) >= 1, str(len(segments)))
        seg_url = playlist_url.rsplit("/", 1)[0] + "/" + segments[0]
        code, seg, _ = get(seg_url)
        check("type A: segment kan hentes", code == 200 and len(seg) > 1000, f"{code}")
        seg_path = os.path.join(root, "a0.ts")
        open(seg_path, "wb").write(seg)
        streams = probe_streams(seg_path)
        check("type A: output er H.264", any("h264" in s for s in streams), str(streams))
        code, chunk, _hdrs = get(seg_url, {"Range": "bytes=0-999"})
        check("Range: 206 med 1000 bytes", code == 206 and len(chunk) == 1000,
              f"{code} {len(chunk)}")

        status, body_b = post_json(base + "/api/prepare", {"url": sources["B"], "start": 0})
        check("type B: /api/prepare svarer ok", status == 200 and body_b.get("ok") is True,
              f"{status} {body_b}")
        check("type B: separat lydspor fundet",
              body_b.get("status", {}).get("separate_audio") is True, str(body_b))
        code, data, _ = get(body_b["url"])
        text_b = data.decode("utf-8", "replace")
        segments_b = [line for line in text_b.splitlines() if line and not line.startswith("#")]
        check("type B: playliste med segmenter", code == 200 and len(segments_b) >= 1, str(code))
        if segments_b:
            code, seg_b, _ = get(body_b["url"].rsplit("/", 1)[0] + "/" + segments_b[0])
            path_b = os.path.join(root, "b0.ts")
            open(path_b, "wb").write(seg_b)
            streams_b = probe_streams(path_b)
            check("type B: både video og lyd i output",
                  any("h264" in s for s in streams_b) and any("aac" in s for s in streams_b),
                  str(streams_b))

        status, again = post_json(base + "/api/prepare", {"url": sources["A"], "start": 0})
        check("dublet returnerer same=true", again.get("same") is True and again.get("sid") == sid_a,
              str(again))

        working = ("1\n00:00:13,000 --> 00:00:16,000\nHej Lennart\n\n"
                   "2\n00:00:20,000 --> 00:00:23,000\nAnden linje\n")
        status, restart = post_json(base + "/api/prepare",
                                    {"url": sources["A"], "start": 12, "restart": True})
        check("genstart: nyt sid og starttid sat",
              status == 200 and restart.get("sid") != sid_a
              and abs(restart.get("start", 0) - 12) < 0.01, str(restart)[:300])
        code, data, _ = get(restart["url"])
        check("genstart: playliste efter seek", code == 200 and "#EXTM3U" in
              data.decode("utf-8", "replace"), str(code))
        plain_path = os.path.join(root, "plain0.ts")
        plain_ok = False
        plain_segs = [line for line in data.decode().splitlines()
                      if line and not line.startswith("#")]
        if plain_segs:
            _, plain_seg, _ = get(restart["url"].rsplit("/", 1)[0] + "/" + plain_segs[0])
            open(plain_path, "wb").write(plain_seg)
            plain_ok = len(plain_seg) > 1000

        status, subs = post_json(base + "/api/prepare",
                                 {"url": sources["A"], "start": 12, "restart": True,
                                  "subs": working})
        status_info = subs.get("status", {})
        check("undertekster: cues parset og brændt ind",
              status == 200 and status_info.get("subs_cues") == 2
              and status_info.get("subs_applied") is True, str(subs)[:300])
        code, data, _ = get(subs["url"])
        segs_subs = [line for line in data.decode().splitlines() if line and not line.startswith("#")]
        if segs_subs and plain_ok:
            code, seg_subs, _ = get(subs["url"].rsplit("/", 1)[0] + "/" + segs_subs[0])
            path_subs = os.path.join(root, "subs0.ts")
            open(path_subs, "wb").write(seg_subs)
            score = ssim(plain_path, path_subs)
            check("undertekster: billedet er faktisk ændret",
                  score is not None and score < 0.999, str(score))
        else:
            check("undertekster: sammenligningsgrundlag", False, "ingen segmenter")

        status, err = post_json(base + "/api/prepare", {"start": 0})
        check("manglende url giver 400", status == 400 and err.get("ok") is False, str(status))
        status, err2 = post_json(base + "/api/prepare",
                                 {"url": sources["A"] + ".finnes-ikke", "restart": True})
        check("død kilde giver fejl uden crash", status in (400, 502, 504), str(status))

        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(5)
        sock.sendto(b"MOVYBRIDGE?", ("127.0.0.1", discovery))
        try:
            reply, _ = sock.recvfrom(2048)
            info = json.loads(reply.decode("utf-8"))
            check("UDP-opdagelse svarer", info.get("port") == port, str(info))
        except socket.timeout:
            check("UDP-opdagelse svarer", False, "timeout")
        finally:
            sock.close()

        status, stopped = post_json(base + "/api/stop", {"sid": restart.get("sid", "")})
        check("stop: session fjernet", status == 200 and stopped.get("ok") is True, str(stopped))
        code, _, _ = get(restart["url"])
        check("stop: playlisten er væk", code == 404, str(code))

        code, data, _ = get(base + "/api/logs?limit=400")
        events = {item.get("event") for item in json.loads(data.decode()).get("events", [])}
        needed = {"session_prepared", "ffmpeg_start", "http", "subs_ready"}
        check("loggen dækker hele kæden", needed.issubset(events), str(sorted(needed - events)))

    finally:
        for proc in (bridge_proc, src_proc):
            if proc and proc.poll() is None:
                proc.terminate()
                try:
                    proc.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    proc.kill()
        shutil.rmtree(root, ignore_errors=True)

    failed = [name for name, ok, _ in RESULTS if not ok]
    print()
    if failed:
        print(f"SELVTEST FEJLEDE: {len(failed)} af {len(RESULTS)}")
        for name in failed:
            print("  - " + name)
        return 1
    print(f"SELVTEST OK ({len(RESULTS)} cases)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
