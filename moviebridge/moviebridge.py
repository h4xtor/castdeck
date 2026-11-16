#!/usr/bin/env python3
"""MovieBridge 2.2 — henter en stream med telefonens headers og serverer
H.264/AAC HLS til en Chromecast.

Designet er bevidst konservativt:
  * ingen tredjepartspakker, kun stdlib
  * kilden læses aldrig med -ss; playlister trimmes i stedet
  * hver anmodning logges med tid, så pauseskærms-problemer kan måles
  * alt kan stoppes og ryddes op i vilkårlig rækkefølge
"""

from __future__ import annotations

import json
import os
import re
import shutil
import signal
import socket
import subprocess
import sys
import threading
import time
import traceback
import urllib.error
import urllib.parse
import urllib.request
import uuid
from collections import deque
from dataclasses import dataclass, field
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any, Iterable

VERSION = "2.2"

PORT = int(os.environ.get("MB_PORT", "8097"))
DISCOVERY_PORT = int(os.environ.get("MB_DISCOVERY_PORT", "8098"))
CACHE_ROOT = os.path.expanduser(os.environ.get("MB_CACHE", "~/.cache/moviebridge"))
FFMPEG = os.environ.get("MB_FFMPEG", "ffmpeg")
FFPROBE = os.environ.get("MB_FFPROBE", "ffprobe")

HLS_TIME = float(os.environ.get("MB_HLS_TIME", "4"))
PREBUFFER_SEGMENTS = int(os.environ.get("MB_PREBUFFER_SEGMENTS", "8"))
PREBUFFER_TIMEOUT = float(os.environ.get("MB_PREBUFFER_TIMEOUT", "75"))
CRF = os.environ.get("MB_CRF", "21")
PRESET = os.environ.get("MB_PRESET", "veryfast")
SUBS_FONT_SIZE = os.environ.get("MB_SUBS_FONT_SIZE", "20")
SUBS_FONTS_DIR = os.environ.get("MB_SUBS_FONTS_DIR", "")
SUBS_FONT_NAME = os.environ.get("MB_SUBS_FONT_NAME", "")
SESSION_TTL = float(os.environ.get("MB_SESSION_TTL", "900"))
MAX_PLAYLIST_BYTES = 8 * 1024 * 1024
MAX_SUBS_BYTES = 4 * 1024 * 1024
HTTP_TIMEOUT = float(os.environ.get("MB_HTTP_TIMEOUT", "25"))

LOG_PATH = os.path.join(CACHE_ROOT, "bridge.log")
LOG_RING = 400

_started_at = time.time()
_lock = threading.RLock()
_sessions: dict[str, "Session"] = {}
_events: deque[dict[str, Any]] = deque(maxlen=LOG_RING)
_subs_filter_ok: bool | None = None


# --------------------------------------------------------------------------
# log
# --------------------------------------------------------------------------

def log(event: str, **fields: Any) -> None:
    """Én linje JSON pr. hændelse. Bruges både til drift og til fejlsøgning."""
    rec: dict[str, Any] = {"ts": round(time.time(), 3), "event": event}
    rec.update(fields)
    with _lock:
        _events.append(rec)
    try:
        os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
        with open(LOG_PATH, "a", encoding="utf-8") as fh:
            fh.write(json.dumps(rec, ensure_ascii=False, default=str) + "\n")
    except OSError:
        pass


class BridgeError(Exception):
    def __init__(self, message: str, status: int = 400):
        super().__init__(message)
        self.message = message
        self.status = status


# --------------------------------------------------------------------------
# HTTP-klient til kilden
# --------------------------------------------------------------------------

SKIP_HEADERS = {"host", "content-length", "connection", "accept-encoding", "transfer-encoding"}


def normalize_headers(raw: Any) -> dict[str, str]:
    """Appen sender headers som dict, som liste af 'K: V' eller som [{name,value}]."""
    out: dict[str, str] = {}
    if not raw:
        return out
    if isinstance(raw, dict):
        items: Iterable[tuple[Any, Any]] = raw.items()
    elif isinstance(raw, (list, tuple)):
        pairs: list[tuple[Any, Any]] = []
        for item in raw:
            if isinstance(item, str) and ":" in item:
                k, v = item.split(":", 1)
                pairs.append((k, v))
            elif isinstance(item, dict):
                pairs.append((item.get("name") or item.get("key"), item.get("value")))
        items = pairs
    else:
        return out
    for key, value in items:
        if not key or value is None:
            continue
        name = str(key).strip()
        if not name or name.lower() in SKIP_HEADERS:
            continue
        out[name] = str(value).strip()
    return out


def fetch(url: str, headers: dict[str, str], timeout: float = HTTP_TIMEOUT) -> tuple[str, bytes]:
    req = urllib.request.Request(url, headers=headers or {})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read(MAX_PLAYLIST_BYTES + 1)
            if len(body) > MAX_PLAYLIST_BYTES:
                raise BridgeError("Kilden sendte en playliste der er for stor", 502)
            return resp.geturl(), body
    except urllib.error.HTTPError as exc:
        raise BridgeError(f"Kilden svarede HTTP {exc.code} på {url}", 502) from exc
    except urllib.error.URLError as exc:
        raise BridgeError(f"Kunne ikke nå kilden: {exc.reason}", 502) from exc
    except (socket.timeout, TimeoutError) as exc:
        raise BridgeError("Kilden svarede ikke i tide", 504) from exc


def header_block(headers: dict[str, str]) -> str:
    return "".join(f"{k}: {v}\r\n" for k, v in headers.items() if k.lower() != "user-agent")


def user_agent_of(headers: dict[str, str]) -> str | None:
    for key, value in headers.items():
        if key.lower() == "user-agent":
            return value
    return None


# --------------------------------------------------------------------------
# Playliste-parsing
# --------------------------------------------------------------------------

@dataclass
class Segment:
    duration: float
    uri: str
    tags: list[str] = field(default_factory=list)


@dataclass
class MediaPlaylist:
    url: str
    target_duration: float
    segments: list[Segment]
    ended: bool
    map_tag: str | None

    @property
    def duration(self) -> float:
        return sum(seg.duration for seg in self.segments)


URI_ATTR = re.compile(r'URI="([^"]+)"')


def absolutize_tag(tag: str, base: str) -> str:
    return URI_ATTR.sub(lambda m: 'URI="%s"' % urllib.parse.urljoin(base, m.group(1)), tag)


def parse_media_playlist(url: str, text: str) -> MediaPlaylist:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if not lines or not lines[0].startswith("#EXTM3U"):
        raise BridgeError("Kilden er ikke en HLS-playliste", 502)

    segments: list[Segment] = []
    pending: list[str] = []
    map_tag: str | None = None
    target = 4.0
    ended = False
    duration: float | None = None

    for line in lines:
        if line.startswith("#EXT-X-TARGETDURATION:"):
            try:
                target = float(line.split(":", 1)[1])
            except ValueError:
                pass
            continue
        if line.startswith("#EXT-X-MAP:"):
            map_tag = absolutize_tag(line, url)
            continue
        if line.startswith("#EXTINF:"):
            try:
                duration = float(line.split(":", 1)[1].split(",")[0])
            except ValueError:
                duration = target
            continue
        if line.startswith("#"):
            if line.startswith("#EXT-X-ENDLIST"):
                ended = True
            elif not line.startswith(("#EXT-X-VERSION", "#EXT-X-TARGETDURATION",
                                      "#EXT-X-MEDIA-SEQUENCE", "#EXT-X-DISCONTINUITY-SEQUENCE",
                                      "#EXT-X-PLAYLIST-TYPE", "#EXT-X-INDEPENDENT-SEGMENTS")):
                pending.append(line)
            continue
        if duration is None:
            continue
        segments.append(Segment(duration=duration,
                                uri=urllib.parse.urljoin(url, line),
                                tags=[absolutize_tag(tag, url) for tag in pending]))
        pending = []
        duration = None

    if not segments:
        raise BridgeError("Playlisten indeholder ingen segmenter", 502)
    return MediaPlaylist(url=url, target_duration=target, segments=segments,
                         ended=ended, map_tag=map_tag)


def parse_master(url: str, text: str) -> tuple[str, str | None]:
    """Returnerer (video-playliste-URL, lyd-playliste-URL eller None)."""
    variants: list[tuple[int, str]] = []
    audio_url: str | None = None
    bandwidth: int | None = None
    expect_variant = False

    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        low = line.lower()
        if low.startswith("#ext-x-stream-inf"):
            match = re.search(r"BANDWIDTH=(\d+)", line)
            bandwidth = int(match.group(1)) if match else 0
            expect_variant = True
            continue
        if low.startswith("#ext-x-media:"):
            if "TYPE=AUDIO" in line.upper():
                match = URI_ATTR.search(line)
                if match:
                    audio_url = urllib.parse.urljoin(url, match.group(1))
            continue
        if line.startswith("#"):
            continue
        if expect_variant:
            variants.append((bandwidth or 0, urllib.parse.urljoin(url, line)))
            expect_variant = False
            bandwidth = None

    if not variants:
        # Ikke en master – allerede en medieplayliste.
        return url, audio_url
    variants.sort(key=lambda item: item[0], reverse=True)
    return variants[0][1], audio_url


def trim_index(playlist: MediaPlaylist, start: float) -> tuple[int, float]:
    cumulative = 0.0
    for index, segment in enumerate(playlist.segments):
        if cumulative + segment.duration > start or index == len(playlist.segments) - 1:
            return index, max(0.0, start - cumulative)
        cumulative += segment.duration
    return 0, 0.0


def write_trimmed_playlist(playlist: MediaPlaylist, index: int, path: str, resolve) -> None:
    """Skriver playlisten med alle URI'er peget på broens egen segment-proxy.

    Proxyen er ikke pynt: kildenavne som 'v-0.png' får ellers ffmpeg til at
    gætte forkert demuxer, og headers fra telefonen skal med på hvert segment.
    """
    out = ["#EXTM3U", "#EXT-X-VERSION:3",
           f"#EXT-X-TARGETDURATION:{max(1, round(playlist.target_duration))}",
           "#EXT-X-MEDIA-SEQUENCE:0",
           "#EXT-X-PLAYLIST-TYPE:VOD"]
    if playlist.map_tag:
        out.append(URI_ATTR.sub(lambda m: 'URI="%s"' % resolve(m.group(1), "mp4"),
                                playlist.map_tag))
    for segment in playlist.segments[index:]:
        for tag in segment.tags:
            out.append(URI_ATTR.sub(lambda m: 'URI="%s"' % resolve(m.group(1), "key"), tag))
        out.append(f"#EXTINF:{segment.duration:.6f},")
        out.append(resolve(segment.uri, "m4s" if playlist.map_tag else "ts"))
    # ENDLIST gør at ffmpeg afslutter pænt i stedet for at polle en statisk fil.
    out.append("#EXT-X-ENDLIST")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")


# --------------------------------------------------------------------------
# Undertekster
# --------------------------------------------------------------------------

SRT_TIME = re.compile(
    r"(\d{1,2}):(\d{2}):(\d{2})[,.](\d{1,3})\s*-->\s*(\d{1,2}):(\d{2}):(\d{2})[,.](\d{1,3})")


def _seconds(h: str, m: str, s: str, ms: str) -> float:
    return int(h) * 3600 + int(m) * 60 + int(s) + int(ms.ljust(3, "0")) / 1000.0


def _stamp(value: float) -> str:
    value = max(0.0, value)
    hours, rest = divmod(value, 3600)
    minutes, secs = divmod(rest, 60)
    whole = int(secs)
    millis = int(round((secs - whole) * 1000))
    if millis == 1000:
        whole += 1
        millis = 0
    return f"{int(hours):02d}:{int(minutes):02d}:{whole:02d},{millis:03d}"


def normalize_subtitles(text: str) -> str:
    """Tager SRT eller WebVTT og giver altid SRT tilbage."""
    text = text.replace("\r\n", "\n").replace("\r", "\n").lstrip("\ufeff")
    if text.upper().startswith("WEBVTT"):
        text = text.split("\n", 1)[1] if "\n" in text else ""
        text = re.sub(r"^NOTE\b.*$", "", text, flags=re.MULTILINE)
    blocks: list[str] = []
    for block in re.split(r"\n\s*\n", text.strip()):
        lines = [line for line in block.split("\n") if line.strip()]
        if not lines:
            continue
        match = SRT_TIME.search(block)
        if not match:
            continue
        body_start = next((i for i, line in enumerate(lines) if SRT_TIME.search(line)), 0) + 1
        body = "\n".join(lines[body_start:]) or " "
        blocks.append((_seconds(*match.groups()[:4]), _seconds(*match.groups()[4:]),
                       match.group(0), body))
    if not blocks:
        return ""
    out: list[str] = []
    for number, (start, end, arrow, body) in enumerate(blocks, 1):
        out.append(str(number))
        out.append(f"{_stamp(start)} --> {_stamp(end)}")
        out.append(body)
        out.append("")
    return "\n".join(out)


def shift_subtitles(text: str, offset: float) -> tuple[str, int, float, float]:
    """Flytter tiderne så de passer til den trimmede video. Returnerer også tal."""
    if not text.strip():
        return "", 0, 0.0, 0.0
    shifted: list[str] = []
    cues = 0
    first = 0.0
    last = 0.0
    for block in re.split(r"\n\s*\n", text.strip()):
        lines = block.split("\n")
        match = SRT_TIME.search(block)
        if not match:
            continue
        start = _seconds(*match.groups()[:4]) - offset
        end = _seconds(*match.groups()[4:]) - offset
        if end <= 0:
            continue
        start = max(0.0, start)
        cues += 1
        if cues == 1:
            first = start
        last = end
        body_start = next((i for i, line in enumerate(lines) if SRT_TIME.search(line)), 0) + 1
        body = "\n".join(lines[body_start:]) or " "
        shifted.append(str(cues))
        shifted.append(f"{_stamp(start)} --> {_stamp(end)}")
        shifted.append(body)
        shifted.append("")
    return "\n".join(shifted), cues, first, last


def has_subtitles_filter() -> bool:
    global _subs_filter_ok
    if _subs_filter_ok is not None:
        return _subs_filter_ok
    try:
        result = subprocess.run([FFMPEG, "-hide_banner", "-filters"],
                                capture_output=True, text=True, timeout=20)
        _subs_filter_ok = " subtitles " in result.stdout
    except (OSError, subprocess.SubprocessError):
        _subs_filter_ok = False
    log("subs_filter_check", available=_subs_filter_ok)
    return _subs_filter_ok


# --------------------------------------------------------------------------
# Session
# --------------------------------------------------------------------------

def probe_has_audio(playlist_path: str) -> bool:
    try:
        result = subprocess.run(
            [FFPROBE, "-v", "error", "-select_streams", "a", "-read_intervals", "%+#1",
             "-show_entries", "stream=index", "-of", "csv=p=0", playlist_path],
            capture_output=True, text=True, timeout=40)
        return bool(result.stdout.strip())
    except (OSError, subprocess.SubprocessError):
        return False


class Session:
    def __init__(self, sid: str, key: str, src: str, headers: dict[str, str], start: float,
                 subs_text: str | None, subs_label: str | None):
        self.sid = sid
        self.key = key
        self.src = src
        self.headers = headers
        self.start = max(0.0, start)
        self.subs_text = subs_text or None
        self.subs_label = subs_label
        self.workdir = os.path.join(CACHE_ROOT, "s", sid)
        self.outdir = os.path.join(self.workdir, "out")
        self.proc: subprocess.Popen | None = None
        self.error: str | None = None
        self.created = time.time()
        self.finished_at: float | None = None
        self.converted = False
        self.subs_cues = 0
        self.subs_applied = False
        self.duration_total = 0.0
        self.video_start_offset = 0.0
        self.video_seg_index = 0
        self.audio_seg_index = 0
        self.audio_offset = 0.0
        self.has_separate_audio = False
        self.last_activity = time.time()
        self.ff_log = os.path.join(self.workdir, "ffmpeg.log")
        self.base = f"http://127.0.0.1:{PORT}"
        self.seg_map: dict[str, str] = {}

    def resolve(self, url: str, ext: str) -> str:
        """Registrerer en fjern-URI og giver den et lokalt navn med rigtig endelse."""
        name = f"{len(self.seg_map):05d}.{ext}"
        self.seg_map[name] = url
        return f"{self.base}/src/{self.sid}/{name}"

    # -- livscyklus -----------------------------------------------------

    def prepare(self) -> None:
        os.makedirs(self.outdir, exist_ok=True)
        master_url, body = fetch(self.src, self.headers)
        text = body.decode("utf-8", "replace")
        if "#EXTM3U" not in text[:64]:
            raise BridgeError("Kilden svarede ikke med en HLS-playliste", 502)

        if "#EXT-X-STREAM-INF" in text:
            video_url, audio_url = parse_master(master_url, text)
        else:
            video_url, audio_url = master_url, None

        _, video_body = fetch(video_url, self.headers)
        video_pl = parse_media_playlist(video_url, video_body.decode("utf-8", "replace"))
        self.duration_total = video_pl.duration

        index, offset = trim_index(video_pl, self.start)
        self.video_seg_index, self.video_start_offset = index, offset
        video_path = os.path.join(self.workdir, "in0.m3u8")
        write_trimmed_playlist(video_pl, index, video_path, self.resolve)

        audio_path: str | None = None
        if audio_url:
            _, audio_body = fetch(audio_url, self.headers)
            audio_pl = parse_media_playlist(audio_url, audio_body.decode("utf-8", "replace"))
            a_index, a_offset = trim_index(audio_pl, self.start)
            self.audio_seg_index, self.audio_offset = a_index, a_offset
            audio_path = os.path.join(self.workdir, "in1.m3u8")
            write_trimmed_playlist(audio_pl, a_index, audio_path, self.resolve)
            self.has_separate_audio = True

        subs_path: str | None = None
        if self.subs_text:
            srt = normalize_subtitles(self.subs_text)
            if srt:
                shifted, cues, first, last = shift_subtitles(srt, self.start)
                if shifted:
                    subs_path = os.path.join(self.workdir, "subs.srt")
                    with open(subs_path, "w", encoding="utf-8") as fh:
                        fh.write(shifted)
                    self.subs_cues = cues
                    log("subs_ready", sid=self.sid, label=self.subs_label, cues=cues,
                        first=round(first, 2), last=round(last, 2), shift=self.start)
                else:
                    log("subs_empty_after_shift", sid=self.sid, label=self.subs_label,
                        shift=self.start)
            else:
                log("subs_unparsed", sid=self.sid, label=self.subs_label,
                    bytes=len(self.subs_text))

        if subs_path and not has_subtitles_filter():
            log("subs_skipped_no_libass", sid=self.sid)
            subs_path = None

        muxed_audio = audio_path is None and probe_has_audio(video_path)
        self._spawn(video_path, audio_path, subs_path, muxed_audio)
        log("session_prepared", sid=self.sid, start=self.start,
            index=index, offset=round(offset, 3), duration=round(self.duration_total, 2),
            separate_audio=audio_path is not None, muxed_audio=muxed_audio,
            subs=bool(subs_path), segments=len(video_pl.segments))

    def _spawn(self, video_path: str, audio_path: str | None, subs_path: str | None,
               muxed_audio: bool) -> None:
        ua = user_agent_of(self.headers)
        common: list[str] = ["-hide_banner", "-nostdin", "-y", "-loglevel", "warning"]
        if ua:
            common += ["-user_agent", ua]

        def input_args(path: str) -> list[str]:
            # -reconnect findes ikke for en lokal playliste; -rw_timeout gør.
            args = ["-rw_timeout", "15000000"]
            block = header_block(self.headers)
            if block:
                args += ["-headers", block]
            # Playlisten ligger lokalt, så ffmpeg låser ellers protokoller til file:
            # segmenterne er absolutte http-URL'er og skal lukkes ind.
            args += ["-protocol_whitelist", "file,http,https,tcp,tls,crypto,data",
                     "-f", "hls", "-allowed_extensions", "ALL", "-i", path]
            return args

        filters: list[str] = []
        if audio_path:
            filters.append(f"[0:v]trim=start={self.video_start_offset:.3f},"
                           f"setpts=PTS-STARTPTS[v0]")
            filters.append(f"[1:a]atrim=start={self.audio_offset:.3f},"
                           f"asetpts=PTS-STARTPTS[a0]")
            audio_map = "[a0]"
        elif muxed_audio:
            filters.append(f"[0:v]trim=start={self.video_start_offset:.3f},"
                           f"setpts=PTS-STARTPTS[v0]")
            filters.append(f"[0:a]atrim=start={self.video_start_offset:.3f},"
                           f"asetpts=PTS-STARTPTS[a0]")
            audio_map = "[a0]"
        else:
            filters.append(f"[0:v]trim=start={self.video_start_offset:.3f},"
                           f"setpts=PTS-STARTPTS[v0]")
            audio_map = ""

        video_out = "[v0]"
        if subs_path:
            expression = "subtitles=subs.srt"
            if SUBS_FONTS_DIR and os.path.isdir(SUBS_FONTS_DIR):
                expression += ":fontsdir=%s" % SUBS_FONTS_DIR
            style = []
            if SUBS_FONT_NAME:
                style.append("FontName=%s" % SUBS_FONT_NAME)
            style.append("FontSize=%s" % SUBS_FONT_SIZE)
            expression += ":force_style='%s'" % ",".join(style)
            filters.append("[v0]%s[v1]" % expression)
            video_out = "[v1]"
            self.subs_applied = True

        cmd: list[str] = [FFMPEG] + common + input_args(video_path)
        if audio_path:
            cmd += input_args(audio_path)
        cmd += ["-filter_complex", ";".join(filters),
                "-map", video_out]
        if audio_map:
            cmd += ["-map", audio_map, "-c:a", "aac", "-b:a", "160k", "-ac", "2", "-ar", "48000"]
        else:
            cmd += ["-an"]
        cmd += [
            "-c:v", "libx264", "-preset", PRESET, "-crf", CRF,
            "-profile:v", "high", "-level", "4.1", "-pix_fmt", "yuv420p",
            "-g", str(int(HLS_TIME * 25)), "-keyint_min", str(int(HLS_TIME * 25)),
            "-sc_threshold", "0", "-force_key_frames", f"expr:gte(t,n_forced*{HLS_TIME:g})",
            "-f", "hls", "-hls_time", f"{HLS_TIME:g}", "-hls_list_size", "0",
            "-hls_playlist_type", "event", "-hls_flags", "independent_segments+temp_file",
            "-hls_segment_filename", os.path.join(self.outdir, "seg%05d.ts"),
            os.path.join(self.outdir, "index.m3u8"),
        ]

        log("ffmpeg_start", sid=self.sid, cmd=" ".join(cmd))
        with open(self.ff_log, "ab") as fh:
            self.proc = subprocess.Popen(cmd, cwd=self.workdir, stdout=fh,
                                         stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
                                         start_new_session=True)
        threading.Thread(target=self._watch, name=f"watch-{self.sid}", daemon=True).start()

    def _watch(self) -> None:
        proc = self.proc
        if proc is None:
            return
        code = proc.wait()
        self.converted = code == 0
        self.finished_at = time.time()
        if code != 0:
            tail = self.ff_tail()
            self.error = f"ffmpeg afsluttede med kode {code}"
            log("ffmpeg_failed", sid=self.sid, code=code, tail=tail)
        else:
            if self.subs_applied:
                tail = self.ff_tail(80)
                if "fontselect: failed" in tail:
                    log("subs_font_missing", sid=self.sid, tail=tail[-400:])
            log("ffmpeg_done", sid=self.sid, segments=len(self.ready_segments()))

    def ff_tail(self, lines: int = 12) -> str:
        try:
            with open(self.ff_log, "r", encoding="utf-8", errors="replace") as fh:
                return "".join(fh.readlines()[-lines:]).strip()
        except OSError:
            return ""

    def alive(self) -> bool:
        return self.proc is not None and self.proc.poll() is None

    def stop(self) -> None:
        proc = self.proc
        if proc and proc.poll() is None:
            try:
                proc.terminate()
                proc.wait(timeout=8)
            except subprocess.TimeoutExpired:
                proc.kill()
                try:
                    proc.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    pass
            except OSError:
                pass
        self.proc = None
        log("session_stopped", sid=self.sid)

    def purge(self) -> None:
        self.stop()
        shutil.rmtree(self.workdir, ignore_errors=True)
        log("session_purged", sid=self.sid)

    # -- segmenter ------------------------------------------------------

    def ready_segments(self) -> list[tuple[str, float]]:
        playlist = os.path.join(self.outdir, "index.m3u8")
        segments: list[tuple[str, float]] = []
        try:
            with open(playlist, "r", encoding="utf-8", errors="replace") as fh:
                duration = None
                for raw in fh:
                    line = raw.strip()
                    if line.startswith("#EXTINF:"):
                        try:
                            duration = float(line.split(":", 1)[1].split(",")[0])
                        except ValueError:
                            duration = HLS_TIME
                    elif line and not line.startswith("#") and duration is not None:
                        segments.append((line, duration))
                        duration = None
        except OSError:
            pass
        return segments

    def wait_ready(self, minimum: int, timeout: float) -> list[tuple[str, float]]:
        deadline = time.time() + timeout
        while True:
            segments = self.ready_segments()
            if len(segments) >= minimum or (self.finished_at and segments):
                return segments
            if self.error:
                if segments:
                    return segments
                raise BridgeError(self.error, 502)
            if not self.alive() and not segments:
                raise BridgeError(self.error or "ffmpeg stoppede uden at lave segmenter", 502)
            if time.time() > deadline:
                if segments:
                    return segments
                raise BridgeError("Kilden leverede ikke segmenter i tide", 504)
            time.sleep(0.25)

    def build_playlist(self, segments: list[tuple[str, float]]) -> str:
        complete = bool(self.finished_at and self.converted)
        target = max(1, int(round(max((d for _, d in segments), default=HLS_TIME))))
        out = ["#EXTM3U", "#EXT-X-VERSION:3", f"#EXT-X-TARGETDURATION:{target}",
               "#EXT-X-MEDIA-SEQUENCE:0", "#EXT-X-INDEPENDENT-SEGMENTS"]
        out.append("#EXT-X-PLAYLIST-TYPE:VOD" if complete else "#EXT-X-PLAYLIST-TYPE:EVENT")
        for name, duration in segments:
            out.append(f"#EXTINF:{duration:.3f},")
            out.append(name)
        if complete:
            out.append("#EXT-X-ENDLIST")
        return "\n".join(out) + "\n"

    def status(self) -> dict[str, Any]:
        segments = self.ready_segments()
        return {
            "sid": self.sid,
            "state": "done" if self.finished_at and self.converted else
                     ("failed" if self.error else "converting"),
            "error": self.error,
            "src": self.src,
            "start": self.start,
            "duration": round(self.duration_total, 2),
            "segments": len(segments),
            "converted_seconds": round(sum(d for _, d in segments), 2),
            "separate_audio": self.has_separate_audio,
            "subs_cues": self.subs_cues,
            "subs_applied": self.subs_applied,
            "age": round(time.time() - self.created, 1),
        }


# --------------------------------------------------------------------------
# Sessionstyring
# --------------------------------------------------------------------------

def _new_sid() -> str:
    return uuid.uuid4().hex[:12]


def prepare_session(body: dict[str, Any], host: str) -> dict[str, Any]:
    src = pick(body, "url", "master", "masterUrl", "master_url", "src", "stream", "link", "m3u8")
    if not src or not isinstance(src, str):
        raise BridgeError("feltet 'url' mangler")
    src = src.strip()
    if not src.startswith(("http://", "https://")):
        raise BridgeError("'url' skal være http eller https")

    headers = normalize_headers(pick(body, "headers", "hdrs", "requestHeaders", "request_headers"))
    start = as_float(pick(body, "start", "startTime", "start_time", "position", "t", "offset"), 0.0)
    restart = as_bool(pick(body, "restart", "force", "reload"))
    subs = pick(body, "subs", "subtitle", "subtitles", "srt", "sub")
    subs_label = pick(body, "subsLabel", "subs_label", "label", "lang")
    if isinstance(subs, dict):
        subs_label = subs.get("label") or subs_label
        subs = subs.get("srt") or subs.get("content") or subs.get("text")
    if subs is not None and not isinstance(subs, str):
        subs = None
    if subs and len(subs.encode("utf-8", "ignore")) > MAX_SUBS_BYTES:
        raise BridgeError("underteksten er for stor")

    key = dedupe_key(src, body)
    with _lock:
        existing = next((s for s in _sessions.values() if s.key == key), None)
        if existing and not restart:
            same_start = abs(existing.start - start) <= 2.0
            same_subs = (existing.subs_text or "") == (subs or "")
            if same_start and same_subs and not existing.error:
                log("dedupe_hit", sid=existing.sid, start=start)
                return {"ok": True, "same": True, "sid": existing.sid,
                        "url": session_url(existing.sid, host), "version": VERSION}
        if existing:
            existing.purge()
            _sessions.pop(existing.sid, None)

        sid = _new_sid()
        session = Session(sid, key, src, headers, start, subs, str(subs_label) if subs_label else None)
        _sessions[sid] = session

    try:
        session.prepare()
    except BridgeError:
        with _lock:
            _sessions.pop(sid, None)
        session.purge()
        raise
    except Exception as exc:  # uventet fejl skal ikke dræbe tjenesten
        log("prepare_crash", sid=sid, error=str(exc), trace=traceback.format_exc(limit=6))
        with _lock:
            _sessions.pop(sid, None)
        session.purge()
        raise BridgeError(f"kunne ikke forberede streamen: {exc}", 500) from exc

    return {"ok": True, "same": False, "sid": sid, "url": session_url(sid, host),
            "version": VERSION, "start": round(session.start, 2),
            "duration": round(session.duration_total, 2),
            "subs": session.subs_cues, "status": session.status()}


def dedupe_key(src: str, body: dict[str, Any]) -> str:
    folder = pick(body, "folder", "dir", "path", "show")
    if folder:
        return f"folder:{folder}"
    parsed = urllib.parse.urlsplit(src)
    return f"url:{parsed.netloc}{parsed.path}"


def session_url(sid: str, host: str) -> str:
    if not host:
        host = f"{local_ip()}:{PORT}"
    elif ":" not in host.rsplit("]", 1)[-1]:
        host = f"{host}:{PORT}"
    return f"http://{host}/s/{sid}/index.m3u8"


def pick(body: dict[str, Any], *names: str) -> Any:
    for name in names:
        if name in body and body[name] is not None:
            return body[name]
    lowered = {str(k).lower(): v for k, v in body.items()}
    for name in names:
        if name.lower() in lowered:
            return lowered[name.lower()]
    return None


def as_float(value: Any, default: float) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def as_bool(value: Any) -> bool:
    if isinstance(value, bool):
        return value
    if isinstance(value, (int, float)):
        return value != 0
    if isinstance(value, str):
        return value.strip().lower() in {"1", "true", "yes", "ja", "on"}
    return False


def local_ip() -> str:
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.connect(("192.168.0.1", 9))
        ip = sock.getsockname()[0]
        sock.close()
        return ip
    except OSError:
        return "127.0.0.1"


def reap_sessions() -> None:
    now = time.time()
    with _lock:
        stale = [s for s in _sessions.values()
                 if s.finished_at and now - s.finished_at > SESSION_TTL]
    for session in stale:
        with _lock:
            _sessions.pop(session.sid, None)
        session.purge()


# --------------------------------------------------------------------------
# HTTP
# --------------------------------------------------------------------------

CONTENT_TYPES = {
    ".m3u8": "application/vnd.apple.mpegurl",
    ".ts": "video/mp2t",
    ".m4s": "video/iso.segment",
    ".mp4": "video/mp4",
    ".vtt": "text/vtt",
    ".srt": "application/x-subrip",
}


class Handler(BaseHTTPRequestHandler):
    server_version = f"MovieBridge/{VERSION}"
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt: str, *args: Any) -> None:  # pragma: no cover
        pass

    # -- hjælpere -------------------------------------------------------

    def host_header(self) -> str:
        return self.headers.get("Host", "") or f"{local_ip()}:{PORT}"

    def send_json(self, payload: dict[str, Any], status: int = 200) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(body)

    def read_body(self) -> dict[str, Any]:
        length = int(self.headers.get("Content-Length") or 0)
        if length <= 0:
            return {}
        if length > 8 * 1024 * 1024:
            raise BridgeError("anmodningen er for stor", 413)
        raw = self.rfile.read(length)
        try:
            data = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            raise BridgeError("body skal være JSON") from exc
        if not isinstance(data, dict):
            raise BridgeError("body skal være et JSON-objekt")
        return data

    def send_file(self, path: str, cache: str = "public, max-age=3600") -> None:
        try:
            size = os.path.getsize(path)
            fh = open(path, "rb")
        except OSError:
            self.send_json({"ok": False, "error": "filen findes ikke"}, 404)
            return
        with fh:
            start, end = 0, size - 1
            status = 200
            range_header = self.headers.get("Range")
            if range_header:
                match = re.match(r"bytes=(\d*)-(\d*)$", range_header.strip())
                if match:
                    if match.group(1):
                        start = int(match.group(1))
                        end = int(match.group(2)) if match.group(2) else size - 1
                    elif match.group(2):
                        start = max(0, size - int(match.group(2)))
                    end = min(end, size - 1)
                    if start > end or start >= size:
                        self.send_response(416)
                        self.send_header("Content-Range", f"bytes */{size}")
                        self.send_header("Content-Length", "0")
                        self.end_headers()
                        return
                    status = 206
            length = end - start + 1
            self.send_response(status)
            self.send_header("Content-Type", CONTENT_TYPES.get(os.path.splitext(path)[1].lower(),
                                                              "application/octet-stream"))
            self.send_header("Content-Length", str(length))
            self.send_header("Accept-Ranges", "bytes")
            self.send_header("Cache-Control", cache)
            if status == 206:
                self.send_header("Content-Range", f"bytes {start}-{end}/{size}")
            self.end_headers()
            if self.command == "HEAD":
                return
            fh.seek(start)
            remaining = length
            while remaining > 0:
                chunk = fh.read(min(65536, remaining))
                if not chunk:
                    break
                self.wfile.write(chunk)
                remaining -= len(chunk)

    # -- routing --------------------------------------------------------

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Range")
        self.send_header("Access-Control-Allow-Methods", "GET, HEAD, POST, OPTIONS")
        self.send_header("Content-Length", "0")
        self.end_headers()

    def do_HEAD(self) -> None:
        self.do_GET()

    def do_GET(self) -> None:
        started = time.time()
        status = 500
        try:
            parsed = urllib.parse.urlsplit(self.path)
            path = parsed.path
            if path in ("/", "/health", "/healthz"):
                status = 200
                self.send_json({"ok": True, "service": "moviebridge", "version": VERSION,
                                "port": PORT, "sessions": len(_sessions),
                                "uptime": round(time.time() - _started_at, 1)})
                return
            if path == "/api/status":
                sid = urllib.parse.parse_qs(parsed.query).get("sid", [""])[0]
                with _lock:
                    session = _sessions.get(sid)
                if not session:
                    status = 404
                    self.send_json({"ok": False, "error": "ukendt sid"}, 404)
                    return
                status = 200
                self.send_json({"ok": True, **session.status()})
                return
            if path == "/api/logs":
                limit = int(urllib.parse.parse_qs(parsed.query).get("limit", ["120"])[0] or 120)
                with _lock:
                    items = list(_events)[-max(1, min(limit, LOG_RING)):]
                status = 200
                self.send_json({"ok": True, "events": items})
                return
            if path == "/api/prepare":
                query = {k: v[0] for k, v in urllib.parse.parse_qs(parsed.query).items()}
                status = 200
                self.send_json(prepare_session(query, self.host_header()))
                return
            if path.startswith("/s/"):
                status = self.serve_session(path)
                return
            if path.startswith("/src/"):
                status = self.serve_source(path)
                return
            status = 404
            self.send_json({"ok": False, "error": "ukendt sti"}, 404)
        except BridgeError as exc:
            status = exc.status
            self.send_json({"ok": False, "error": exc.message}, exc.status)
        except BrokenPipeError:
            status = 499
        except Exception as exc:  # pragma: no cover
            log("http_crash", path=self.path, error=str(exc),
                trace=traceback.format_exc(limit=6))
            status = 500
            try:
                self.send_json({"ok": False, "error": "intern fejl"}, 500)
            except OSError:
                pass
        finally:
            log("http", method=self.command, path=self.path, status=status,
                ms=int((time.time() - started) * 1000),
                client=self.client_address[0] if self.client_address else "")

    def do_POST(self) -> None:
        started = time.time()
        status = 500
        try:
            parsed = urllib.parse.urlsplit(self.path)
            if parsed.path in ("/api/prepare", "/api/session"):
                body = self.read_body()
                status = 200
                self.send_json(prepare_session(body, self.host_header()))
                return
            if parsed.path == "/api/stop":
                body = self.read_body()
                sid = str(pick(body, "sid", "session", "id") or "")
                status = self.stop_session(sid)
                return
            status = 404
            self.send_json({"ok": False, "error": "ukendt sti"}, 404)
        except BridgeError as exc:
            status = exc.status
            self.send_json({"ok": False, "error": exc.message}, exc.status)
        except Exception as exc:  # pragma: no cover
            log("http_crash", path=self.path, error=str(exc),
                trace=traceback.format_exc(limit=6))
            status = 500
            try:
                self.send_json({"ok": False, "error": "intern fejl"}, 500)
            except OSError:
                pass
        finally:
            log("http", method=self.command, path=self.path, status=status,
                ms=int((time.time() - started) * 1000),
                client=self.client_address[0] if self.client_address else "")

    def serve_source(self, path: str) -> int:
        """Videresender et kilde-segment med telefonens headers på."""
        parts = path.strip("/").split("/")
        if len(parts) != 3:
            self.send_json({"ok": False, "error": "ugyldig sti"}, 404)
            return 404
        sid, name = parts[1], parts[2]
        with _lock:
            session = _sessions.get(sid)
            target = session.seg_map.get(name) if session else None
        if not session or not target:
            self.send_json({"ok": False, "error": "ukendt segment"}, 404)
            return 404
        request = urllib.request.Request(target, headers=session.headers or {})
        try:
            upstream = urllib.request.urlopen(request, timeout=HTTP_TIMEOUT)
        except urllib.error.HTTPError as exc:
            log("source_error", sid=sid, name=name, status=exc.code)
            self.send_json({"ok": False, "error": f"kilden svarede {exc.code}"}, 502)
            return 502
        except (urllib.error.URLError, OSError) as exc:
            log("source_error", sid=sid, name=name, error=str(exc))
            self.send_json({"ok": False, "error": "kilden kunne ikke nås"}, 502)
            return 502

        ext = name.rsplit(".", 1)[-1].lower()
        content_type = {"ts": "video/mp2t", "m4s": "video/iso.segment",
                        "mp4": "video/mp4", "key": "application/octet-stream"}.get(
                            ext, "application/octet-stream")
        try:
            with upstream:
                length = upstream.headers.get("Content-Length")
                self.send_response(200)
                self.send_header("Content-Type", content_type)
                if length:
                    self.send_header("Content-Length", length)
                self.send_header("Cache-Control", "public, max-age=600")
                # ffmpeg 6/7 har en crash med genbrugte keep-alive-forbindelser
                # til segmenter; én forbindelse pr. segment er billigt her.
                self.send_header("Connection", "close")
                self.close_connection = True
                self.end_headers()
                if self.command == "HEAD":
                    return 200
                while True:
                    chunk = upstream.read(65536)
                    if not chunk:
                        break
                    self.wfile.write(chunk)
        except (BrokenPipeError, ConnectionResetError):
            return 499
        except (urllib.error.URLError, OSError) as exc:
            log("source_stream_error", sid=sid, name=name, error=str(exc))
            return 502
        return 200

    def stop_session(self, sid: str) -> int:
        with _lock:
            session = _sessions.pop(sid, None) if sid else None
            if session is None:
                # Ingen sid: stop alt, det er hvad afspilleren vil have ved exit.
                sessions = list(_sessions.values())
                _sessions.clear()
            else:
                sessions = [session]
        for item in sessions:
            item.purge()
        self.send_json({"ok": True, "stopped": len(sessions)})
        return 200

    def serve_session(self, path: str) -> int:
        parts = path.strip("/").split("/")
        if len(parts) < 3:
            self.send_json({"ok": False, "error": "ugyldig sti"}, 404)
            return 404
        sid, name = parts[1], parts[2]
        with _lock:
            session = _sessions.get(sid)
        if not session:
            self.send_json({"ok": False, "error": "sessionen findes ikke"}, 404)
            return 404
        session.last_activity = time.time()

        if name in ("index.m3u8", "master.m3u8", "playlist.m3u8"):
            segments = session.wait_ready(PREBUFFER_SEGMENTS, PREBUFFER_TIMEOUT)
            body = session.build_playlist(segments).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", CONTENT_TYPES[".m3u8"])
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            if self.command != "HEAD":
                self.wfile.write(body)
            return 200

        if not re.fullmatch(r"seg\d{5}\.ts", name):
            self.send_json({"ok": False, "error": "ugyldigt filnavn"}, 404)
            return 404
        target = os.path.join(session.outdir, name)
        if not os.path.exists(target):
            self.send_json({"ok": False, "error": "segmentet findes ikke endnu"}, 404)
            return 404
        self.send_file(target)
        return 200


# --------------------------------------------------------------------------
# Opdagelse på UDP 8098
# --------------------------------------------------------------------------

def discovery_loop() -> None:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        sock.bind(("0.0.0.0", DISCOVERY_PORT))
    except OSError as exc:
        log("discovery_bind_failed", port=DISCOVERY_PORT, error=str(exc))
        return
    log("discovery_listening", port=DISCOVERY_PORT)
    ip = local_ip()
    while True:
        try:
            data, addr = sock.recvfrom(2048)
        except OSError:
            return
        probe = data.decode("utf-8", "replace").lower()
        if "movybridge" not in probe and "moviebridge" not in probe and "discover" not in probe:
            continue
        reply = json.dumps({
            "service": "moviebridge",
            "version": VERSION,
            "port": PORT,
            "http": f"http://{ip}:{PORT}",
            "name": socket.gethostname(),
        }).encode("utf-8")
        try:
            sock.sendto(reply, addr)
            log("discovery_reply", client=addr[0])
        except OSError:
            pass


# --------------------------------------------------------------------------
# Opstart
# --------------------------------------------------------------------------

def sweep_cache() -> None:
    shutil.rmtree(os.path.join(CACHE_ROOT, "s"), ignore_errors=True)


def main() -> int:
    os.makedirs(CACHE_ROOT, exist_ok=True)
    sweep_cache()
    for tool in (FFMPEG, FFPROBE):
        if shutil.which(tool) is None:
            print(f"[moviebridge] mangler værktøjet: {tool}", file=sys.stderr)
            return 2

    has_subtitles_filter()
    log("start", version=VERSION, port=PORT, discovery=DISCOVERY_PORT,
        cache=CACHE_ROOT, prebuffer=PREBUFFER_SEGMENTS, hls_time=HLS_TIME)

    threading.Thread(target=discovery_loop, name="discovery", daemon=True).start()

    server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    server.daemon_threads = True

    def shutdown(signum: int, _frame: Any) -> None:
        log("shutdown", signal=signum, sessions=len(_sessions))
        threading.Thread(target=server.shutdown, daemon=True).start()

    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)

    def reaper() -> None:
        while True:
            time.sleep(30)
            try:
                reap_sessions()
            except Exception as exc:  # pragma: no cover
                log("reaper_error", error=str(exc))

    threading.Thread(target=reaper, name="reaper", daemon=True).start()

    print(f"[moviebridge] {VERSION} lytter på :{PORT} (opdagelse UDP {DISCOVERY_PORT})",
          flush=True)
    try:
        server.serve_forever(poll_interval=0.5)
    finally:
        with _lock:
            sessions = list(_sessions.values())
            _sessions.clear()
        for session in sessions:
            session.purge()
        server.server_close()
        log("stopped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
