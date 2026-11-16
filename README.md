# castdeck

Cast-first source deck: MovieBench (Android) + MovieBridge (X280) + det der
hører til, så film kan sendes fra telefonen til Chromecast Ultra / Philips 65".

## Hvad ligger her

```
moviebridge/          MovieBridge 2.2 — Python-tjenesten på X280
  moviebridge.py      hele tjenesten, kun stdlib
  selftest.py         22 kontroller mod falske kilder (type A og type B)
  install.sh          installation, selvtest, systemd
  LAES-MIG.md         dansk vejledning til Lennart
```

## Status

| Del | Status |
|---|---|
| MovieBridge 2.2 | færdig, selvtest 22/22 grøn |
| Testet mod type A (fMP4-HLS) | ja |
| Testet mod type B (TS med .png-navne, separat lyd) | ja |
| Testet på rigtig telefon og TV | nej — kun falske kilder |
| MovieBench-APK (undertekster, skjult afspiller) | afventer APK + byggeprojekt |

## MovieBridge 2.2 — kort

- Kilden læses aldrig med `-ss`; playlister trimmes, og der skæres med
  `trim`/`atrim`, så lyd og billede bliver i sync (også separat lydspor).
- Alle kildesegmenter går gennem broen med telefonens headers.
- Playlisten er `EVENT` under konvertering og skifter til komplet `VOD` med
  `ENDLIST`, når filmen er færdig — det er modtrækket mod pauseskærmen.
- 8 segmenter (ca. 32 sek.) ligger klar, før første playliste udleveres.
- Undertekster: SRT eller WebVTT ind, forskudt til starttid, brændt ind med
  libass. Hvert led logges, og manglende skrifttype rapporteres eksplicit.
- Hver HTTP-anmodning logges med sti, status og tid.

## Næste skridt

APK-delen kræver den nuværende APK, smali-træet og byggeprojektet. De ligger
ikke her endnu. Så snart de er uploadet, kan undertekstkæden og den skjulte
afspiller arbejdes igennem på samme måde: mål først, ret bagefter.
