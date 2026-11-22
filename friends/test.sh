#!/usr/bin/env bash
# Runs the plain-JDK tests for the Android-independent Friends classes
# (VttBuilder, SubServer). No phone or Android SDK needed.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
command -v cygpath >/dev/null 2>&1 && HERE="$(cygpath -m "$HERE")"
OUT="$HERE/out/test-cls"
rm -rf "$OUT" && mkdir -p "$OUT"
javac --release 11 -encoding UTF-8 -d "$OUT" \
    "$HERE/src/sx/movybench/VttBuilder.java" \
    "$HERE/src/sx/movybench/SubServer.java" \
    "$HERE/test/sx/movybench/FriendsTests.java"
java -cp "$OUT" sx.movybench.FriendsTests
