#!/usr/bin/env bash
# Builds Friends MovieBench (sx.movybench.friends) from the untouched release
# APK in original/ plus the Java sources in src/. The regular MovieBench and
# MovieBridge are not touched.
#
#   MB_KS_PASS=<keystore password> bash friends/build.sh
#
# Needs: JDK 17+ (javac/java), Python 3, the toolbox in ../tools.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
# Git Bash on Windows: hand Java/Python native C:/ paths, not /c/ paths.
if command -v cygpath >/dev/null 2>&1; then
    HERE="$(cygpath -m "$HERE")"
    REPO="$(cygpath -m "$REPO")"
fi
TOOLS="$REPO/tools"
ANDROID_JAR="$TOOLS/plat/android-35/android.jar"
D8="$TOOLS/bt/android-14/lib/d8.jar"
APKSIGNER="$TOOLS/bt/android-14/lib/apksigner.jar"
APKTOOL="$TOOLS/apktool.jar"
KEYSTORE="${MB_KEYSTORE:-$REPO/mb.keystore}"
VCODE="${FRIENDS_VERSION_CODE:-14}"
VNAME="${FRIENDS_VERSION_NAME:-1.13-friends}"
OUT="$HERE/out"
APK_NAME="MovieBench_Friends_${VNAME}.apk"

: "${MB_KS_PASS:?set MB_KS_PASS to the mb.keystore password}"

rm -rf "$OUT"
mkdir -p "$OUT/cls" "$OUT/dex" "$OUT/test-cls"

echo "== 1/8 decode original release APK"
java -jar "$APKTOOL" d -f -o "$OUT/dec" "$HERE/original/MovieBench_Friends.apk" >/dev/null

echo "== 2/8 patch smali"
python "$HERE/tools/patch_smali.py" "$OUT/dec" "$VCODE" "$VNAME"

echo "== 3/8 stubs + javac"
python "$HERE/tools/gen_stubs.py" "$OUT/stubs" >/dev/null
find "$HERE/src" "$OUT/stubs" -name '*.java' > "$OUT/sources.txt"
javac --release 11 -nowarn -encoding UTF-8 -cp "$ANDROID_JAR" -d "$OUT/cls" @"$OUT/sources.txt"

echo "== 4/8 d8 (only our classes, never the stubs)"
OWN=$(cd "$OUT/cls" && ls sx/movybench/FriendsCast*.class sx/movybench/SubServer*.class sx/movybench/VttBuilder*.class)
(cd "$OUT/cls" && java -cp "$D8" com.android.tools.r8.D8 --release --min-api 26 \
    --lib "$ANDROID_JAR" --classpath "$OUT/cls" --output "$OUT/dex" $OWN)

echo "== 5/8 check dex contents (no stub may leak)"
python "$HERE/tools/dex_classes.py" "$OUT/dex/classes.dex"

echo "== 6/8 apktool build"
java -jar "$APKTOOL" b "$OUT/dec" -o "$OUT/rebuilt.apk" >/dev/null

echo "== 7/8 align + sign"
python "$HERE/tools/align.py" "$OUT/rebuilt.apk" "$OUT/aligned.apk" "$OUT/dex/classes.dex"
java -jar "$APKSIGNER" sign --ks "$KEYSTORE" --ks-key-alias mb \
    --ks-pass env:MB_KS_PASS --key-pass env:MB_KS_PASS \
    --out "$OUT/$APK_NAME" "$OUT/aligned.apk"

echo "== 8/8 verify"
java -jar "$APKSIGNER" verify --print-certs "$OUT/$APK_NAME" | grep -E "Signer #1 certificate (DN|SHA-256)"
java -jar "$APKTOOL" d -f -s -o "$OUT/verify" "$OUT/$APK_NAME" >/dev/null
grep -o 'package="[^"]*"' "$OUT/verify/AndroidManifest.xml"
grep -E "versionCode|versionName" "$OUT/verify/apktool.yml"
python "$HERE/tools/check_refs.py" "$OUT/$APK_NAME" "$OUT/dex/classes.dex" "$OUT/dec"
ls "$OUT/verify" | grep -c '^classes' | xargs echo "dex files:"
echo "APK: $OUT/$APK_NAME"
