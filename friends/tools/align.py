"""Re-zips an apktool output so it installs on Android 11+ (targetSdk 34):
resources.arsc and media stored uncompressed and 4-byte aligned (what
zipalign does), old signatures stripped. Same logic as build/repack.py,
without injecting an extra dex.

Usage: python align.py <in.apk> <out.apk> [extra.dex]
The optional extra dex is added as the next free classesN.dex.
"""
import sys
import zipfile

SRC, OUT = sys.argv[1], sys.argv[2]
EXTRA = sys.argv[3] if len(sys.argv) > 3 else None
STORE = ("resources.arsc", ".png", ".jpg", ".jpeg", ".gif", ".webp", ".so")

zin = zipfile.ZipFile(SRC)
zout = zipfile.ZipFile(OUT, "w")
names = zin.namelist()
ordered = [n for n in names if n == "resources.arsc"] + [n for n in names if n != "resources.arsc"]
for n in ordered:
    if n.startswith("META-INF/") and (n.endswith(".RSA") or n.endswith(".SF") or n.endswith(".MF")):
        continue
    info = zin.getinfo(n)
    data = zin.read(n)
    zi = zipfile.ZipInfo(n, date_time=info.date_time)
    zi.external_attr = info.external_attr
    zi.create_system = 0
    low = n.lower()
    if any(low == k or low.endswith(k) for k in STORE):
        zi.compress_type = zipfile.ZIP_STORED
        pos = zout.fp.tell()
        pad = (-(pos + 30 + len(n.encode("utf-8")))) % 4
        zi.extra = b"\x00" * pad
        zout.writestr(zi, data, compress_type=zipfile.ZIP_STORED)
    else:
        zout.writestr(zi, data, compress_type=zipfile.ZIP_DEFLATED)
if EXTRA:
    n = 2
    while ("classes%d.dex" % n) in names:
        n += 1
    name = "classes%d.dex" % n
    zi = zipfile.ZipInfo(name, date_time=(2026, 1, 1, 0, 0, 0))
    zi.create_system = 0
    zout.writestr(zi, open(EXTRA, "rb").read(), compress_type=zipfile.ZIP_DEFLATED)
    print("added", name)
zout.close()
zin.close()
print("aligned:", OUT)
