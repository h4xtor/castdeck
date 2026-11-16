# Byg MovieBench-APK'en (v9 = 1.8-x280)

Her er hele app-projektet: smali-træet i `dec/`, Java-kilden til de nye/rettede
klasser i `src/`, compile-stubs i `stubs/` og om-pakningen i `repack.py`.
Værktøjskassen ligger nu i `../tools/` (android.jar-35, d8, apktool,
apksigner), så trinene virker direkte efter en clone. Kun JDK'en (Temurin 21,
hentes fra adoptium.net) og signerings-nøglen `mb.keystore` ligger udenfor.

## Byggetrin (Windows PowerShell)

1. **Ryd gammelt javac-output** — vigtigt, ellers crasher d8:

   - Slet `build\cls\com` helt.
   - Slet alle `build\cls\sx\movybench\*.class` UNDTAGET `CastHelper*`
     (de to `CastHelper*`-klasser kommer fra smali-træet og genbruges).

2. **Oversæt Java:**

   ```
   javac --release 11 -cp tools\plat\android-35\android.jar -d build\cls ^
     (alle .java i build\src og build\stubs)
   ```

3. **Lav dex** (kun vores egne klasser — stubs må aldrig med):

   ```
   java -cp d8.jar com.android.tools.r8.D8 --release --min-api 24 ^
     --lib tools\plat\android-35\android.jar --output build\dex ^
     (alle build\cls\sx\movybench\*.class)
   ```

4. **Byg APK af smali-træet:**

   ```
   java -jar apktool.jar b build\dec -o build\rebuilt.apk
   ```

5. **Om-pak** (lægger classes3.dex i, holder resources.arsc ukomprimeret og
   justeret, stripper gamle signaturer):

   ```
   python build\repack.py build\rebuilt.apk build\out.apk build\dex\classes.dex
   ```

6. **Signér og navngiv:**

   ```
   apksigner sign --ks mb.keystore --ks-pass pass:moviebench --ks-key-alias mb ^
     --key-pass pass:moviebench --out MovieBench_x280_v9.apk build\out.apk
   ```

Nøglen ligger i repo-roden (`mb.keystore`, 2,5 KB) og hemmelighederne i
`NOEGLE-INFO.txt`: alias `mb`, adgangskode `moviebench`, pakke `sx.movybench`.
Samme certifikat er brugt til alle udgivelser — mistes den, kan fremtidige
udgivelser ikke opdatere de installerede APK'er.

## Kendte faldgruber

- **d8 crasher med NPE på anonyme klasse-filer** (`Cannot invoke
  "String.length()"`): altid ryddet som i trin 1. Java-kilden bruger derfor
  ingen lambdas eller anonyme klasser — kun navngivne statiske indre klasser.
- **`stubs/` er kun til javac** — stubsene faker Google Cast-klasserne, så
  javac kan oversætte; på telefonen bruges de rigtige gms-klasser. De må
  aldrig blive dexet.
- **Verificér altid efter bygning:** `apktool d --no-src` på den færdige APK
  og læs `versionInfo` i `apktool.yml` (skal stå versionCode 9 /
  versionName 1.8-x280), plus `apksigner verify --print-certs`
  (SHA-256 `377b6110a2d3…d5e1b50`).
- **Ingen aapt.exe i værktøjskassen:** smoke-test køres derfor via
  `sx.movybench/.MainActivity` — `WebPlayerActivity` er ikke exported og kan
  ikke startes direkte med adb.

## Hvad der er patchet i smali-træet

- `smali_classes2/sx/movybench/Catalog.smali` — Rayplayer-kortet (side 42,
  https://rayplayer.com/da, mærke "dansk · live tekster").
- `smali_classes2/sx/movybench/WebPlayerActivity.smali` — alle 4
  `CastHelper.load`-kald peger nu på `CastLoadSub.load` (dansk tekstspor).
- `apktool.yml` — versionCode 9, versionName 1.8-x280.

## App-klasser (src/)

- `CastLoadSub.java` (ny) — baggrundstråd: lader broen klare streamen, venter
  op til 60 sekunder på de danske tekster, bygger load-requesten med
  MediaTrack "Dansk" (id 1) og aktiverer sporet efter load.
- `Bridge.java` — sender `want_da: true` i /api/prepare, gemmer `sub_url` i
  `lastSubUrl`.
- `CastRemote.java` — `modeStr()`-hjælper + genstartssporet bruger
  CastLoadSub.
- Resten er de eksisterende klasser, som projektet bygges sammen med.
