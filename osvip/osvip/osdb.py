"""OSDb movie hash: 64-bit little-endian sum of the first 64 KiB plus file size."""
from __future__ import annotations

import os

CHUNK = 65536


def moviehash(path: str) -> str:
    size = os.path.getsize(path)
    with open(path, "rb") as f:
        head = f.read(CHUNK)
    h = sum(int.from_bytes(head[i:i + 4], "little") for i in range(0, len(head) - 3, 4))
    h += size
    h &= 0xFFFFFFFFFFFFFFFF
    return f"{h:016x}"
