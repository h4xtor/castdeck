"""Lists the classes defined in a .dex file and fails if any class outside the
allowed Friends set is present (stub classes must never be dexed: they would
shadow the real Cast SDK / app classes and cause VerifyError or crashes).

Usage: python dex_classes.py <classes.dex>
"""
import re
import struct
import sys

ALLOWED = re.compile(r"^Lsx/movybench/(FriendsCast|SubServer|VttBuilder)(\$[A-Za-z0-9_]+)?;$")


def uleb(data, pos):
    result, shift = 0, 0
    while True:
        b = data[pos]
        pos += 1
        result |= (b & 0x7F) << shift
        if b < 0x80:
            return result, pos
        shift += 7


def main(path):
    d = open(path, "rb").read()
    if d[:4] != b"dex\n":
        raise SystemExit("not a dex file")
    string_ids_off = struct.unpack_from("<I", d, 0x3C)[0]
    type_ids_off = struct.unpack_from("<I", d, 0x44)[0]
    class_defs_size, class_defs_off = struct.unpack_from("<II", d, 0x60)

    def string(i):
        off = struct.unpack_from("<I", d, string_ids_off + 4 * i)[0]
        _, pos = uleb(d, off)
        end = d.index(b"\x00", pos)
        return d[pos:end].decode("utf-8", "replace")

    def type_name(i):
        return string(struct.unpack_from("<I", d, type_ids_off + 4 * i)[0])

    names = [type_name(struct.unpack_from("<I", d, class_defs_off + 32 * k)[0])
             for k in range(class_defs_size)]
    bad = [n for n in names if not ALLOWED.match(n)]
    for n in sorted(names):
        print("  class", n)
    if bad:
        raise SystemExit("foreign classes in dex: " + ", ".join(bad))
    print("dex ok: %d Friends classes" % len(names))


if __name__ == "__main__":
    main(sys.argv[1])
