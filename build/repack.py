#!/usr/bin/env python3
"""Repack: laeg classes3.dex i, behold resources.arsc ukomprimeret og 4-byte justeret
(local file header padding, som zipalign goer), strip gamle signaturer."""
import sys
import zipfile

SRC = sys.argv[1] if len(sys.argv) > 1 else "build/rebuilt.apk"
OUT = sys.argv[2] if len(sys.argv) > 2 else "build/out.apk"
DEX3 = sys.argv[3] if len(sys.argv) > 3 else "build/dex/classes.dex"

STORE_KEYS = ("resources.arsc", ".png", ".jpg", ".jpeg", ".gif", ".webp")
STRIP_PREFIXES = ("META-INF/",)


def stored(name):
    low = name.lower()
    return any(low == k or low.endswith(k) for k in STORE_KEYS)


zin = zipfile.ZipFile(SRC)
zout = zipfile.ZipFile(OUT, "w")
names = zin.namelist()
ordered = [n for n in names if n == "resources.arsc"]
ordered += [n for n in names if n != "resources.arsc"]

for n in ordered:
    if any(n == p or n.startswith(p) for p in STRIP_PREFIXES):
        continue
    info = zin.getinfo(n)
    data = zin.read(n)
    zi = zipfile.ZipInfo(n, date_time=info.date_time)
    zi.external_attr = info.external_attr
    zi.create_system = 0
    if stored(n):
        zi.compress_type = zipfile.ZIP_STORED
        pos = zout.fp.tell()
        pad = (-(pos + 30 + len(n.encode("utf-8")))) % 4
        zi.extra = b"\x00" * pad
        zout.writestr(zi, data, compress_type=zipfile.ZIP_STORED)
    else:
        zi.compress_type = zipfile.ZIP_DEFLATED
        zout.writestr(zi, data, compress_type=zipfile.ZIP_DEFLATED)

d3 = open(DEX3, "rb").read()
zi = zipfile.ZipInfo("classes3.dex", date_time=(2026, 1, 1, 0, 0, 0))
zi.compress_type = zipfile.ZIP_DEFLATED
zi.create_system = 0
zout.writestr(zi, d3, compress_type=zipfile.ZIP_DEFLATED)
zout.close()
zin.close()
print("ok: " + OUT)
