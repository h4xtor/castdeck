# MovieBridge 2.2

Broen mellem MovieBench på telefonen og TV'et. Den henter filmen med telefonens
headers, laver den om til H.264/AAC-HLS og serverer den til Chromecast'en.

## Installation

Hent repoet som zip (Code, Download ZIP på GitHub), pak det ud, og kør:

    cd ~/Hentet/castdeck-main/moviebridge
    sudo bash install.sh

Har du allerede moviebridge.zip i Hentet, virker den gamle vej også:

    cd ~/Hentet
    unzip -o moviebridge.zip
    cd moviebridge
    sudo bash install.sh

Installationen kører selvtesten først. Fejler den, bliver der intet installeret.
Ved geninstallation overskrives koden, og tjenesten genstartes.

## Sådan tjekker du den

- curl -s http://192.168.0.4:8097/healthz — svarer den, kører den.
- journalctl -u moviebridge -f — live log.
- curl -s http://192.168.0.4:8097/api/logs?limit=50 — de sidste hændelser.

## Indstillinger

Sættes i /etc/systemd/system/moviebridge.service under [Service], og kræver
sudo systemctl daemon-reload og sudo systemctl restart moviebridge.

Variabler: MB_PORT (8097), MB_DISCOVERY_PORT (8098), MB_PREBUFFER_SEGMENTS (8),
MB_PREBUFFER_TIMEOUT (75), MB_HLS_TIME (4), MB_CRF (21), MB_PRESET (veryfast),
MB_SUBS_FONT_SIZE (20), MB_SUBS_FONTS_DIR (tom), MB_SUBS_FONT_NAME (tom),
MB_SESSION_TTL (900).

## Hvis noget ikke virker

Ingen undertekster: kig efter subs_ready, subs_applied og subs_font_missing i
loggen. subs_cues 0 betyder at teksten ikke kunne læses. subs_font_missing
betyder at der mangler en skrifttype (sudo apt install fonts-dejavu-core).

TV'et går på pauseskærm: se http-linjerne. Kommer der stadig anmodninger om
playlisten og segmenter, mens det sker? Hvis nej, er det TV'et der giver op.

Port 8097 er optaget: ss -ltnp viser hvem. Stop den anden tjeneste, eller sæt
MB_PORT til noget andet.

Intet billede: prøv playlisten i VLC på PC'en. Virker den der, er problemet på
TV-siden.

## Afinstallation

    sudo bash install.sh --uninstall

Fjerner tjenesten og /opt/moviebridge.
