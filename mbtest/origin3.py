import http.server, sys
d=open('frag60.mp4','rb').read()
boxes=[];pos=0
while pos<len(d):
    s=int.from_bytes(d[pos:pos+4],'big');boxes.append((d[pos+4:pos+8],d[pos:pos+s]));pos+=s
init=b''.join(b for t,b in boxes if t in(b'ftyp',b'moov'))
frs=[];cur=b''
for t,b in boxes:
    if t==b'moof': cur=b
    elif t==b'mdat': frs.append(cur+b);cur=b''
print(len(init),len(frs),flush=True)
class H(http.server.BaseHTTPRequestHandler):
    protocol_version="HTTP/1.1"
    def log_message(self,*a): pass
    def do_GET(self):
        if self.headers.get("Referer")!="https://movy.example/":
            body=b"x";code=403
        elif self.path=="/vd/TOK":
            body=init;code=200   # ignorerer Range, som den rigtige: altid startfilen
            code=206 if self.headers.get("Range") else 200
        elif self.path.startswith("/vd/TOK/seg-") and self.path.endswith("-s1080p-v1-a1.m4s"):
            n=int(self.path.split("seg-")[1].split("-")[0])
            if 1<=n<=len(frs): body=frs[n-1];code=200
            else: body=b"";code=404
        else: body=b"";code=404
        self.send_response(code);self.send_header("Content-Length",str(len(body)))
        if code==206: self.send_header("Content-Range","bytes 0-%d/%d"%(len(body)-1,len(body)))
        self.end_headers();self.wfile.write(body)
http.server.ThreadingHTTPServer(("127.0.0.1",9421),H).serve_forever()
