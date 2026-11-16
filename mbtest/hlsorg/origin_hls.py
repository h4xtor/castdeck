import http.server, os, re, sys, collections
F = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/mbtest/hlsorg/files"
HITS = collections.Counter()
MASTER = """#EXTM3U
#EXT-X-VERSION:7
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud",NAME="English",LANGUAGE="en",DEFAULT=YES,AUTOSELECT=YES,URI="audio_english.m3u8.png"
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="English",LANGUAGE="en",DEFAULT=NO,AUTOSELECT=NO,URI="subtitles_english.m3u8.png"
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="Dansk",LANGUAGE="da",DEFAULT=NO,AUTOSELECT=NO,URI="subtitles_danish.m3u8.png"
#EXT-X-STREAM-INF:BANDWIDTH=2500000,RESOLUTION=1280x720,CODECS="avc1.64001f,mp4a.40.2",AUDIO="aud",SUBTITLES="subs"
video_720p.m3u8.png
#EXT-X-STREAM-INF:BANDWIDTH=1200000,RESOLUTION=960x540,CODECS="avc1.64001f,mp4a.40.2",AUDIO="aud",SUBTITLES="subs"
video_540p.m3u8.png
"""
def vtt(part, lang):
    out = "WEBVTT\n\n"
    for i in range(part*30, part*30+30, 5):
        a, b = i, i+3
        f = lambda x: "00:%02d:%02d.000" % (x//60, x%60)
        out += "%d\n%s --> %s\n%s tekst %d\n\n" % (i, f(a), f(b), "Hello" if lang=="en" else "Hej", i)
    return out
def subpl(lang):
    return "#EXTM3U\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n" + "".join(
        "#EXTINF:30.0,\nsubs_%s_%d.vtt.png\n" % (lang, i) for i in range(3)) + "#EXT-X-ENDLIST\n"
class H(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    def log_message(self, *a): pass
    def do_GET(self):
        code, body, ct = 404, b"", "image/png"
        if self.headers.get("Referer") != "https://embed.example/":
            code, body = 403, b"nej"
        else:
            m = re.match(r"^/S01E01/([^/?]+)\.png(\?.*)?$", self.path)
            if m:
                n = m.group(1); HITS[n] += 1
                if n == "index.m3u8":
                    code, body = 200, MASTER.encode()
                elif n.startswith("subtitles_"):
                    code, body = 200, subpl("en" if "english" in n else "da").encode()
                elif n.startswith("subs_"):
                    lang = "en" if "_en_" in n or "english" in n else "da"
                    part = int(re.search(r"_(\d+)\.vtt", n).group(1))
                    code, body = 200, vtt(part, "en" if n.startswith("subs_en_") else "da").encode()
                elif os.path.exists(os.path.join(F, n)):
                    body = open(os.path.join(F, n), "rb").read(); code = 200
                    if n.endswith(".m3u8"):
                        t = body.decode()
                        t = re.sub(r'URI="([^"]+)"', lambda x: 'URI="%s.png"' % x.group(1), t)
                        t = "\n".join((l + ".png") if l and not l.startswith("#") else l for l in t.split("\n"))
                        body = t.encode()
            elif self.path == "/stats":
                code, body, ct = 200, repr(dict(HITS)).encode(), "text/plain"
        self.send_response(code); self.send_header("Content-Type", ct)
        self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body)
http.server.ThreadingHTTPServer(("127.0.0.1", int(sys.argv[2]) if len(sys.argv) > 2 else 9431), H).serve_forever()
