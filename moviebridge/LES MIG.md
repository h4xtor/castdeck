# MovieBridge 2.3 til X280

MovieBridge oversaetter streams, sa din Chromecast og dit Philips Android TV kan afspille dem.
Ny i 2.3: dansk tekstspor direkte til TV'et - broen oversaetter fremmede tekster til dansk,
og Chromecast tegner teksterne selv i stedet for at de braendes ind i billedet.

## Installér (én gang)
Aabn en terminal i mappen, hvor du har pakket filerne ud, og skriv:

    sudo bash install.sh

Derefter koerer den 24/7 og starter af sig selv, naar X280'eren genstarter.
Installationen koerer en selvtest (nu 10 prover: falske sider med stump-video og video+lyd
hver for sig, undertekster, spoling, subs.vtt og dansk tekstspor oversat).
Staer der SELVTEST OK paa alle linjer, er alt klart.

## Ny i 2.3
- **Dansk tekstspor til TV'et:** Appen (1.8-x280) beder om dansk tekstspor, naar den sender
  til TV'et. Broen laver en undertekst-fil (subs_da.vtt) og vedhaefter den som spor, sa
  Chromecast selv tegner teksterne - skarpe, og indbraending i billedet droppes.
- **Oversaettelse til dansk:** Er kildeteksterne engelske (eller andet fremmed sprog), gor
  broen dem til dansk i baggrunden, replik for replik. Tekster appen selv sender med, regnes
  for at vaere danske og klaes videre som de er.
- **To oversaettere:** Argos Translate koerer lokalt paa X280'eren foerst; ellers bruges en
  LibreTranslate-server. Uden nogen af dem braender broen teksterne ind som foer (som 2.2).
- **Foerste gang Argos henter en model** paa ca. 110 MB i baggrunden - det sker kun engang.
  Vil du installere den selv i forvejen: pip3 install argostranslate og derefter
  argospm install translate-en_da
- **Ventetid ved send:** Appen viser "Danske tekster klares til TV'et..." og venter op til
  60 sekunder paa oversaettelsen; derefter gaar den videre med det, der findes. Henter TV'et
  filen foer teksterne er faerdige, kommer original-sproget foerst - tryk Stop og Send igen,
  naar loggen siger "danske tekster faerdige".
- **Gamle apps mærker ingenting:** aeldre end 1.8-x280 faar det gamle indbraendte spor som foer.
- **Flere miljoeindstillinger** (saettes i /etc/moviebridge.conf eller i enhed-filen):
  - MB_TRANSLATE: auto (standard, proever Argos og saa LibreTranslate), argos, libre, off.
    (off = altid indbraending, som i 2.2.)
  - MB_LT_URL: adressen paa en LibreTranslate-server, fx http://127.0.0.1:5000
  - MB_LT_KEY: noegle, hvis serveren kraever en.
  - MB_ARGOS_AUTO: 1 (standard) henter en->da-pakken selv; 0 slaar det fra.

## Brug
- **Fra MovieBench (version 1.8-x280):** Tryk send til TV som normalt (eller lad auto-cast goere det).
  - Med dansk tekstspor viser appen kort "Danske tekster klares til TV'et..." foerst.
  - Appen stopper selv afspilningen paa telefonen, naar TV'et er gaaet i gang.
  - Nederst kommer en fjernbetjening: spolebjaelke, +30 / -30, pause/afspil, Tekst (skifter
    undertekster) og Stop.
  - Tekster fra appen eller fremmede spor oversaettes til dansk og sendes til TV'et som
    tekstspor. Uden oversaetter braendes de ind i billedet, som foer.
  - Virker paa greenkite/movy.sx, 7movies/vidrift/bigbang, popcornmovies, rayplayer.com m.fl.
- **Fra web-siden:** Aabn http://<X280-IP>:8097 paa telefonen eller PC'en, indsaet et link,
  vaelg TV og tryk Send til TV. Web-siden bruger indbraending, som foer.

## Opdater fra 2.2
Pak de nye filer ud (overskriv de gamle) og koer igen:

    sudo bash install.sh

Du behoever ikke at afinstallere foerst - install.sh genbruger tjenesten.
Opdater ogsaa appen paa telefonen (1.8-x280) - ellers intet nyt tekstspor.

## Fejlfinding
- Log paa web-siden (/log), eller i terminalen: journalctl -u moviebridge -n 60 --no-pager
- "ingen oversaetter foelbar" i loggen: saet MB_LT_URL eller install Argos (se ovenfor).
- "oversat 40/300 replikker" staar laenge: Argos oversaetter stille og roligt; TV'et kan
  bruges samtidig, og teksterne opdateres naar de er faerdige.
- Genstart: sudo systemctl restart moviebridge
- Fjern igen: sudo bash uninstall.sh
