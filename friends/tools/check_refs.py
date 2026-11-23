"""Link check for the injected Friends dex (guards against VerifyError /
NoSuchMethodError on the phone).

Every method and field that classes7.dex references in a non-platform class
(Google Cast SDK, sx.movybench app code) must be defined - same name, same
signature - by some dex in the final APK, or inherited from a superclass
that defines it.

Usage: python check_refs.py <app.apk> <friends.dex>
"""
import struct
import sys
import zipfile

PLATFORM = ("Ljava/", "Ljavax/", "Landroid/", "Ldalvik/", "Lorg/json/", "Lorg/xml/", "Lorg/w3c/")


def uleb(d, p):
    r = s = 0
    while True:
        b = d[p]
        p += 1
        r |= (b & 0x7F) << s
        if b < 0x80:
            return r, p
        s += 7


class Dex:
    def __init__(self, d):
        self.d = d
        h = struct.unpack_from("<IIIIIIIIIIIIII", d, 0x38)
        (self.str_n, self.str_off, self.type_n, self.type_off, self.proto_n, self.proto_off,
         self.field_n, self.field_off, self.meth_n, self.meth_off, self.cls_n, self.cls_off,
         _, _) = h

    def s(self, i):
        off = struct.unpack_from("<I", self.d, self.str_off + 4 * i)[0]
        _, p = uleb(self.d, off)
        return self.d[p:self.d.index(b"\x00", p)].decode("utf-8", "replace")

    def t(self, i):
        return self.s(struct.unpack_from("<I", self.d, self.type_off + 4 * i)[0])

    def proto(self, i):
        _, ret, params = struct.unpack_from("<III", self.d, self.proto_off + 12 * i)
        args = ""
        if params:
            n = struct.unpack_from("<I", self.d, params)[0]
            args = "".join(self.t(struct.unpack_from("<H", self.d, params + 4 + 2 * k)[0]) for k in range(n))
        return "(" + args + ")" + self.t(ret)

    def method(self, i):
        c, p, n = struct.unpack_from("<HHI", self.d, self.meth_off + 8 * i)
        return self.t(c), self.s(n), self.proto(p)

    def field(self, i):
        c, ty, n = struct.unpack_from("<HHI", self.d, self.field_off + 8 * i)
        return self.t(c), self.s(n), self.t(ty)

    def classes(self):
        """yields (class, superclass, [methods], [fields]) for defined classes"""
        for k in range(self.cls_n):
            ci, _, sup, _, _, _, data, _ = struct.unpack_from("<IIIIIIII", self.d, self.cls_off + 32 * k)
            name = self.t(ci)
            sname = self.t(sup) if sup != 0xFFFFFFFF else None
            meths, fields = [], []
            if data:
                p = data
                sf, p = uleb(self.d, p)
                inf, p = uleb(self.d, p)
                dm, p = uleb(self.d, p)
                vm, p = uleb(self.d, p)
                for cnt in (sf, inf):
                    idx = 0
                    for _ in range(cnt):
                        diff, p = uleb(self.d, p)
                        _, p = uleb(self.d, p)
                        idx += diff
                        fields.append(self.field(idx))
                for cnt in (dm, vm):
                    idx = 0
                    for _ in range(cnt):
                        diff, p = uleb(self.d, p)
                        _, p = uleb(self.d, p)
                        _, p = uleb(self.d, p)
                        idx += diff
                        meths.append(self.method(idx))
            yield name, sname, meths, fields


def main(apk, own):
    z = zipfile.ZipFile(apk)
    supers, defm, deff, ifaces = {}, set(), set(), {}
    for n in z.namelist():
        if n.startswith("classes") and n.endswith(".dex"):
            dx = Dex(z.read(n))
            for name, sup, ms, fs in dx.classes():
                supers[name] = sup
                defm.update(ms)
                deff.update(fs)
    me = Dex(open(own, "rb").read())
    own_classes = {c for c, _, _, _ in me.classes()}

    def defined(kind, cls, name, sig):
        seen = set()
        c = cls
        while c and c not in seen:
            seen.add(c)
            if (c, name, sig) in (defm if kind == "m" else deff):
                return True
            c = supers.get(c)
        return False

    missing, checked = [], 0
    for i in range(me.meth_n):
        c, n, sig = me.method(i)
        if c in own_classes or c.startswith(PLATFORM) or c.startswith("["):
            continue
        checked += 1
        if c not in supers:
            missing.append("class missing: " + c)
        elif not defined("m", c, n, sig):
            missing.append("method missing: %s->%s%s" % (c, n, sig))
    for i in range(me.field_n):
        c, n, ty = me.field(i)
        if c in own_classes or c.startswith(PLATFORM):
            continue
        checked += 1
        if not defined("f", c, n, ty):
            missing.append("field missing: %s->%s:%s" % (c, n, ty))
    for m in sorted(set(missing)):
        print("  " + m)
    if missing:
        raise SystemExit("%d unresolved references" % len(set(missing)))
    print("refs ok: %d external app/SDK references resolve in the APK" % checked)
    return me


def reverse(me, dec_dir):
    """Patched smali -> FriendsCast: every call target must exist in our dex."""
    import os
    import re
    own = set()
    for _, _, ms, _ in me.classes():
        own.update(ms)
    pat = re.compile(r"(Lsx/movybench/(?:FriendsCast|FriendsAutoSub|AutoSubPolicy|SubServer|VttBuilder)[^;]*;)->([\w<>$]+)(\([^)]*\)\S+)")
    calls, bad = 0, []
    for root, _, files in os.walk(dec_dir):
        for f in files:
            if f.endswith(".smali"):
                for m in pat.finditer(open(os.path.join(root, f), encoding="utf-8").read()):
                    calls += 1
                    if (m.group(1), m.group(2), m.group(3)) not in own:
                        bad.append("%s->%s%s" % m.groups())
    if bad:
        raise SystemExit("smali calls missing in Friends dex: " + ", ".join(sorted(set(bad))))
    print("reverse ok: %d smali call sites into Friends classes resolve" % calls)


if __name__ == "__main__":
    dex = main(sys.argv[1], sys.argv[2])
    if len(sys.argv) > 3:
        reverse(dex, sys.argv[3])
