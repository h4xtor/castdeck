set -e
B=/home/claude/build
rm -rf $B/cls && mkdir -p $B/cls $B/dex
javac --release 11 -cp /home/claude/tools/plat/android-35/android.jar -d $B/cls $(find $B/src -name '*.java') $(find $B/stubs -name '*.java') 2>&1 | grep -v "^Note:" || true
# fjern stubs foer dex
rm -rf $B/cls/com $B/cls/sx/movybench/CastHelper*.class
FILES=$(find $B/cls -name '*.class')
/home/claude/tools/bt/android-14/d8 --release --min-api 24 --lib /home/claude/tools/plat/android-35/android.jar --output $B/dex $FILES
ls -la $B/dex
