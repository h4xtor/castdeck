# Som origin.py, men: /cap/<fil>  -> max 1 MB pr. svar (206 med ærlig Content-Range, også uden Range)
#                     /trunc/<fil> -> lover fuld laengde, men lukker efter 1 MB
import http.server, socketserver, os, re, sys
ROOT=sys.argv[1]; CAP=1_000_000
class H(http.server.BaseHTTPRequestHandler):
    protocol_version="HTTP/1.1"
    def log_message(self,*a): pass
    def do_GET(self):
        if self.headers.get("Referer")!="https://movy.example/" or "tok=abc" not in (self.headers.get("Cookie") or ""):
            self.send_response(403); self.send_header("Content-Length","0"); self.end_headers(); return
        mode,_,name=self.path.lstrip("/").partition("/")
        fp=os.path.join(ROOT,name.split("?")[0])
        if not os.path.isfile(fp): self.send_response(404); self.send_header("Content-Length","0"); self.end_headers(); return
        size=os.path.getsize(fp); a,b=0,size-1
        m=re.match(r"bytes=(\d+)-(\d*)",self.headers.get("Range") or "")
        if m: a=int(m.group(1)); b=int(m.group(2)) if m.group(2) else size-1
        if a>=size: self.send_response(416); self.send_header("Content-Range",f"bytes */{size}"); self.send_header("Content-Length","0"); self.end_headers(); return
        b=min(b,size-1)
        if mode=="cap":
            b=min(b,a+CAP-1)
            self.send_response(206); self.send_header("Content-Range",f"bytes {a}-{b}/{size}")
            n=b-a+1; send=n
        else:  # trunc
            self.send_response(206 if m else 200)
            if m: self.send_header("Content-Range",f"bytes {a}-{b}/{size}")
            n=b-a+1; send=min(n,CAP)
        self.send_header("Content-Type","video/mp4"); self.send_header("Accept-Ranges","bytes"); self.send_header("Content-Length",str(n))
        self.send_header("Connection","close"); self.end_headers(); self.close_connection=True
        with open(fp,"rb") as f:
            f.seek(a)
            try: self.wfile.write(f.read(send))
            except (BrokenPipeError,ConnectionResetError): pass
class S(socketserver.ThreadingMixIn, http.server.HTTPServer): daemon_threads=True; allow_reuse_address=True
S(("127.0.0.1",9402),H).serve_forever()
