"""Applies the Friends Cast/subtitle patches to a freshly decoded
MovieBench_Friends.apk tree (apktool d). Every patch checks its exact anchor
and fails loudly if the smali does not look as expected, so a different input
APK can never be patched half-way.

Usage: python patch_smali.py <decoded-dir> <versionCode> <versionName>
"""
import os
import re
import sys

DEC = sys.argv[1]
VCODE = sys.argv[2]
VNAME = sys.argv[3]


def path(rel):
    for d in sorted(os.listdir(DEC)):
        if d.startswith("smali"):
            p = os.path.join(DEC, d, rel)
            if os.path.exists(p):
                return p
    raise SystemExit("missing smali file: " + rel)


def patch(rel, old, new, count=1):
    p = path(rel)
    with open(p, encoding="utf-8") as f:
        s = f.read()
    n = s.count(old)
    if n != count:
        raise SystemExit("anchor found %d times (want %d) in %s:\n%s" % (n, count, rel, old))
    s = s.replace(old, new)
    with open(p, "w", encoding="utf-8", newline="\n") as f:
        f.write(s)
    print("patched", rel)


# 1. Friends never uses MovieBridge: phone mode is always on, no Termux bridge.
patch("sx/movybench/CastFlow.smali",
      ".method static phoneMode(Landroid/content/Context;)Z\n    .locals 2\n",
      ".method static phoneMode(Landroid/content/Context;)Z\n    .locals 2\n\n"
      "    invoke-static {p0}, Lsx/movybench/CastFlow;->friends(Landroid/content/Context;)Z\n\n"
      "    move-result v0\n\n"
      "    if-eqz v0, :friends_no\n\n"
      "    const/4 v0, 0x1\n\n"
      "    return v0\n\n"
      "    :friends_no\n")
patch("sx/movybench/CastFlow.smali",
      ".method static phoneBridge(Landroid/content/Context;)Ljava/lang/String;\n    .locals 2\n",
      ".method static phoneBridge(Landroid/content/Context;)Ljava/lang/String;\n    .locals 2\n\n"
      "    invoke-static {p0}, Lsx/movybench/CastFlow;->friends(Landroid/content/Context;)Z\n\n"
      "    move-result v0\n\n"
      "    if-eqz v0, :friends_no\n\n"
      "    const/4 v0, 0x0\n\n"
      "    return-object v0\n\n"
      "    :friends_no\n")
patch("sx/movybench/CastFlow.smali",
      'const-string v1, "Kr\\u00e6ver lokal MovieBridge i Termux. Sl\\u00e5 fra for direkte Cast."',
      'const-string v1, "Ikke i brug i Friends: undertekster sendes direkte fra telefonen til TV\'et."')

# 2. CastHelper.load -> FriendsCast.load (old body kept as loadLegacy).
patch("sx/movybench/CastHelper.smali",
      ".method public static load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;"
      "Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V\n",
      ".method public static load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;"
      "Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V\n"
      "    .locals 0\n\n"
      "    invoke-static/range {p0 .. p4}, Lsx/movybench/FriendsCast;->load(Landroid/content/Context;"
      "Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V\n\n"
      "    return-void\n"
      ".end method\n\n"
      ".method public static loadLegacy(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;"
      "Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V\n")

# 3. Changing subtitles (CC menu / timing) while casting updates the TV.
patch("sx/movybench/CastRemote.smali",
      ".method static selectCaption(Landroid/app/Activity;Ljava/lang/String;)Z\n    .locals 3\n",
      ".method static selectCaption(Landroid/app/Activity;Ljava/lang/String;)Z\n    .locals 3\n\n"
      "    invoke-static {p0, p1}, Lsx/movybench/FriendsCast;->selectCaption(Landroid/app/Activity;"
      "Ljava/lang/String;)Z\n\n"
      "    move-result v0\n\n"
      "    if-eqz v0, :friends_no\n\n"
      "    return v0\n\n"
      "    :friends_no\n")

# 3b. Subtitles that arrive on the phone while casting (CC search -> download ->
# SubtitleOverlay.set -> CastRemote.onSubs) are pushed on to the TV.
patch("sx/movybench/CastRemote.smali",
      ".method public static onSubs(Ljava/lang/String;)V\n    .locals 3\n",
      ".method public static onSubs(Ljava/lang/String;)V\n    .locals 3\n\n"
      "    invoke-static {p0}, Lsx/movybench/FriendsCast;->onSubs(Ljava/lang/String;)V\n")

# 4. Phone overlay: honour the timing offset, and clearing also clears the TV text.
patch("sx/movybench/SubtitleOverlay.smali",
      ".method public render(J)V\n    .locals 5\n",
      ".method public render(J)V\n    .locals 5\n\n"
      "    invoke-static {p1, p2}, Lsx/movybench/FriendsCast;->subTime(J)J\n\n"
      "    move-result-wide p1\n")
patch("sx/movybench/SubtitleOverlay.smali",
      ".method public clear()V\n    .locals 2\n",
      ".method public clear()V\n    .locals 2\n\n"
      "    const/4 v0, 0x0\n\n"
      "    invoke-static {v0}, Lsx/movybench/CastRemote;->onSubs(Ljava/lang/String;)V\n")

# 5. Accessor for the private CC timing offset.
patch("sx/movybench/CcMenu.smali",
      ".method static mode()Ljava/lang/String;\n",
      ".method static offsetSeconds()D\n"
      "    .locals 2\n\n"
      "    sget-wide v0, Lsx/movybench/CcMenu;->offset:D\n\n"
      "    return-wide v0\n"
      ".end method\n\n"
      ".method static mode()Ljava/lang/String;\n")

# 6. Srt.stripTags: the ASS-tag regex "\{\\[^}]*}" leaves the final } unescaped.
# Android/ICU rejects a bare } (PatternSyntaxException), so Srt.cues() throws on
# any OpenSubtitles .srt that carries {\anX}-style tags. On the phone the overlay
# swallows it (subtitles silently vanish); on Cast it killed the prep thread and
# no video/subtitles reached the TV. Escaping } -> \} fixes both paths.
patch("sx/movybench/sub/Srt.smali",
      r'const-string v0, "\\{\\\\[^}]*}"',
      r'const-string v0, "\\{\\\\[^}]*\\}"')

# 7. Version: upgrade over the installed Friends 1.12 (versionCode 13).
yml = os.path.join(DEC, "apktool.yml")
with open(yml, encoding="utf-8") as f:
    y = f.read()
if "versionCode: 13" not in y or "versionName: 1.12" not in y:
    raise SystemExit("unexpected version in apktool.yml")
y = re.sub(r"versionCode: \d+", "versionCode: " + VCODE, y)
y = re.sub(r"versionName: \S+", "versionName: " + VNAME, y)
with open(yml, "w", encoding="utf-8", newline="\n") as f:
    f.write(y)
print("version", VCODE, VNAME)

man = os.path.join(DEC, "AndroidManifest.xml")
with open(man, encoding="utf-8") as f:
    if 'package="sx.movybench.friends"' not in f.read():
        raise SystemExit("input is not the Friends APK")
print("package sx.movybench.friends ok")
