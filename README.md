# castdeck

Cast-first source deck: MovieBench (Android) + MovieBridge (X280) + det der
hører til, så film kan sendes fra telefonen til Chromecast Ultra / Philips 65".

Denne branch (`OpenCode-Moviebench`) er hele arbejdsstanden fra
OpenCode-sessionen: MovieBridge 2.3 med dansk tekstspor + MovieBench v9
(1.8-x280) med Rayplayer og dansk tekstspor til TV'et.

## Hvad ligger her

```
moviebridge/          MovieBridge 2.3 — Python-tjenesten på X280
  moviebridge.py      hele tjenesten + indbygget selvtest
                      (python3 moviebridge.py --selftest)
  install.sh          installation, selvtest, systemd
  uninstall.sh        fjern tjenesten igen
  LES MIG.md          dansk vejledning
tools/                byggeværktøjskassen (android.jar-35, d8, apksigner, apktool)
mbtest/               testmedier og logs fra tidligere forsøg
build/                MovieBench-app-projektet
  dec/                smali-træet (decompileret APK + vores patches)
  src/                Java-kilden til de nye/rettede klasser
  stubs/              compile-stubs (kun til javac — må aldrig dexes)
  repack.py           lægger classes3.dex i og aligner resources.arsc
  mkdex.sh            d8-trinnet som shell-script
  BYG.md              byggeopskrift trin for trin
  MovieBench_*.apk    hele APK-historikken (cast, x280, trace, v3–v9)
deliver/              klar-til-brug
  MovieBridge_2_3.zip
  MovieBench_x280_v9.apk
testpics/             skærmbilleder fra testene (1–5 v6-tid, 6–10 v8/v9 + Rayplayer)
```

JDK'en (Temurin 21, hentes fra adoptium.net) er det eneste, der ikke er i
repoet. Signerings-nøglen `mb.keystore` ligger i repo-roden med hemmeligheder
i `NOEGLE-INFO.txt` (alias `mb`, kode `moviebench`).

## Status

| Del | Status |
|---|---|
| MovieBridge 2.3 | færdig, selvtest grøn (12 prøver) |
| Dansk tekstspor til TV'et | kodet + selvtest grøn; venter på rigtig Chromecast |
| Oversættelse (Argos lokal, LibreTranslate-reserve) | kodet + selvtest grøn (mock-motor); Argos-model ikke installeret her |
| MovieBench v9 (1.8-x280) | bygget, signeret, selvtestet i BlueStacks |
| Rayplayer.com/da (side 42) | tilføjet, åbnet og afspillet i BlueStacks |
| Testet på rigtig telefon og TV | nej — venter på adgang til telefon |

## MovieBridge 2.3 — kort

- Alt fra 2.2 (trim/atrim i stedet for `-ss`, EVENT→VOD-skift, telefonens
  headers videre til kilden, indbrænding med libass, fuld logning).
- **Ny: dansk tekstspor til TV'et.** Appen (1.8-x280) beder om dansk tekstspor
  i /api/prepare (`want_da`). Broen skriver straks en `subs_da.vtt`
  (pass-through) og oversætter i baggrunden replik for replik; filen
  opdateres og versioneret via `?v=` når oversættelsen er færdig. Appen
  vedhæfter filen som Cast MediaTrack, så Chromecast tegner teksterne selv,
  og indbrænding droppes.
- **Oversættelse:** Argos Translate lokalt først (henter en→da-pakken selv
  første gang, ~110 MB), LibreTranslate som reserve (`MB_LT_URL`,
  `MB_LT_KEY`). Vælges med `MB_TRANSLATE`: auto/argos/libre/off. Ingen
  oversætter → gammel indbrænding, som i 2.2.
- Tekster fra appen regnes for at være danske; fremmede spor (lang ikke
  da/dan og navn uden "dansk") oversættes.

## Næste skridt

1. Rigtig test: APK på telefonen, cast til Chromecast Ultra, se om det
   danske spor tegnes pænt — kræver telefon-adgang.
2. Installér Argos en→da på X280'eren (eller lad `MB_ARGOS_AUTO` gøre det)
   og bedøm oversættelseskvaliteten på en rigtig film.
