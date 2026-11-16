import http.server, socketserver, os, re, sys
ROOT=sys.argv[1]
class H(http.server.BaseHTTPRequestHandler):
    protocol_version="HTTP/1.1"
    def log_message(self,*a): pass
    def do_HEAD(self): self.go(False)
    def do_GET(self): self.go(True)
    def go(self, body):
        if self.headers.get("Referer")!="https://movy.example/" or "tok=abc" not in (self.headers.get("Cookie") or ""):
            self.send_response(403); self.send_header("Content-Length","6"); self.end_headers(); body and self.wfile.write(b"DENIED"); return
        fp=os.path.join(ROOT,self.path.split("?")[0].lstrip("/"))
        if not os.path.isfile(fp):
            self.send_response(404); self.send_header("Content-Length","0"); self.end_headers(); return
        size=os.path.getsize(fp); a,b=0,size-1; code=200
        m=re.match(r"bytes=(\d*)-(\d*)",self.headers.get("Range") or "")
        if m:
            code=206
            if m.group(1): a=int(m.group(1)); b=int(m.group(2)) if m.group(2) else size-1
            else: a=size-int(m.group(2))
            b=min(b,size-1)
        self.send_response(code); self.send_header("Content-Type","application/octet-stream")
        self.send_header("Content-Length",str(b-a+1)); self.send_header("Accept-Ranges","bytes")
        if code==206: self.send_header("Content-Range",f"bytes {a}-{b}/{size}")
        self.end_headers()
        if body:
            with open(fp,"rb") as f:
                f.seek(a); left=b-a+1
                try:
                    while left>0:
                        d=f.read(min(65536,left));
                        if not d: break
                        self.wfile.write(d); left-=len(d)
                except (BrokenPipeError,ConnectionResetError): pass
class S(socketserver.ThreadingMixIn, http.server.HTTPServer): daemon_threads=True; allow_reuse_address=True
S(("127.0.0.1",9401),H).serve_forever()
