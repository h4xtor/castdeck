# Sessionsnotat — MovieBench-arbejdet (OpenCode)

Denne branch (`OpenCode-Moviebench`) er hele arbejdsstanden fra
OpenCode-sessionen. Denne fil er noter til dig selv, når du er hjemme —
samtalen med OpenCode følger ikke med, men alt det praktiske gør.

## Alt på branchen (fuld gennemsigtighed)

Koden og leverancerne ovenfor + alt arbejdsområdet er uploadet:
- `tools/` — hele byggeværktøjskassen (android.jar-35, d8, apktool,
  apksigner m.m., ~392 MB), så `build/BYG.md` virker direkte efter en clone.
- `mbtest/` — testmedier, fragmenter og logs fra tidligere forsøg.
- `build/MovieBench_*.apk` — hele APK-historikken (cast, x280, trace,
  v3–v9) + `mkdex.sh`.
- `AGENTS.md` — instruktionsfilen til OpenCode-arbejdet.
- `vaerktoejer/` lokalt er bekræftet en dublet af `tools/` og er derfor ikke
  uploadet.
- Ligger ikke på branchen: JDK'en (hentes fra adoptium.net) og
  signerings-nøglen `mb.keystore` (alias `mb`, pakke sx.movybench —
  adgangskoden står i din lokale NØGLE-INFO.txt).

## Hvad der er lavet

**MovieBridge 2.3 (X280'eren)**
- Ny kæde: appen beder om dansk tekstspor (`want_da`), broen skriver straks
  `subs_da.vtt` (pass-through), oversætter fremmede tekster til dansk i
  baggrunden (Argos lokalt, LibreTranslate som reserve), opdaterer filen og
  bumpet `?v=` når den er færdig.
- Appen vedhæfter filen som Cast MediaTrack "Dansk" (id 1), så Chromecast
  tegner teksterne selv — indbrænding springes over når sporet tager over.
- Ingen oversætter tilgængelig → gammel indbrænding, som i 2.2. Gamle apps
  mærker ingenting.
- Selvtest: 12/12 grøn (inkl. engelsk spor hentet → oversat → fil hentet
  over HTTP).

**MovieBench v9 (1.8-x280)**
- Ny klasse `CastLoadSub`: venter op til 60 sek på de danske tekster
  ("Danske tekster klares til TV'et..."), bygger load med MediaTrack og
  aktiverer det efter load. Fallback: gammel opførsel uden spor.
- Bridge-klassen sender `want_da: true` og gemmer `sub_url`.
- Rayplayer (rayplayer.com/da) tilføjet som side 42, mærket
  "dansk · live tekster".
- Bygget, signeret (samme cert som altid, SHA-256 377b6110…d5e1b50),
  versionCode 9 verificeret.

## Hvad der er afprøvet her

- Selvtest 12/12 grøn.
- App i BlueStacks: installeret, starter uden fejl, hjemskærm viser 42 sider,
  Rayplayer åbnes (dansk landingsside), stream-detektion ser MP4'en, og
  deres 15:58 demo-video spiller. Se `testpics/6`–`testpics/10`.

## Hvad der mangler at blive bevist

1. **Rigtig Chromecast-test** — tegner TV'et det danske spor pænt? Kræver
   telefon + TV + Chromecast på samme net.
2. **Argos' oversættelseskvalitet** på en rigtig film (modellen er ikke
   installeret her; første brug henter ~110 MB i baggrunden).
3. Skærmsparer-tjekket: at TV'et ikke går i pauseskærm under afspilning.

## Planen når du er hjemme

1. På X280'eren: `git fetch && git checkout OpenCode-Moviebench`, og kør
   `sudo bash install.sh` fra `moviebridge/` (genbruger tjenesten, ingen
   afinstallation).
2. På telefonen: installér `deliver/MovieBench_x280_v9.apk` oven i den gamle
   (samme signatur, så den opdaterer direkte) — viser "1.8-x280".
3. Test: åbn en film, send til TV'et, se om de danske tekster kommer.
   Hentet før oversættelsen er færdig? Tryk Stop og Send igen, når loggen
   siger "danske tekster faerdige".
4. Log: http://<X280-IP>:8097/log — og indstillingerne (MB_TRANSLATE,
   MB_LT_URL osv.) står i `moviebridge/LES MIG.md`.

## Open questions tilbage i samtalen

- Telefon-adgang (h4xtor-phone MCP) til den rigtige Chromecast-test — var
  endnu ikke godkendt.
