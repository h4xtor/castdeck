#!/usr/bin/env bash
# MovieBridge 2.2 — installation på X280 (Linux Mint / Ubuntu)
# Kør:  cd ~/Hentet && unzip -o moviebridge.zip && cd moviebridge && sudo bash install.sh
set -Eeuo pipefail
umask 022

fail() { printf '\n[FEJL] %s\n' "$*" >&2; exit 1; }
info() { printf '\n[MovieBridge] %s\n' "$*"; }

trap 'printf "\n[FEJL] Installationen stoppede ved linje %s.\n" "$LINENO" >&2' ERR

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd -P)"
PREFIX="/opt/moviebridge"
UNIT="/etc/systemd/system/moviebridge.service"
SERVICE_USER="${SUDO_USER:-}"
PORT="${MB_PORT:-8097}"

if [ "$EUID" -ne 0 ]; then
  fail "Kør med sudo: sudo bash install.sh"
fi
case "$SCRIPT_DIR" in
  *" "*) fail "Flyt mappen til en sti uden mellemrum og prøv igen." ;;
esac

if [ "${1:-}" = "--uninstall" ] || [ "${1:-}" = "uninstall" ]; then
  info "Fjerner MovieBridge"
  systemctl disable --now moviebridge.service 2>/dev/null || true
  rm -f "$UNIT"
  systemctl daemon-reload
  rm -rf "$PREFIX"
  info "Væk. Ingen tjeneste, ingen filer i $PREFIX."
  exit 0
fi

[ -n "$SERVICE_USER" ] || fail "Kan ikke se hvilken bruger der kørte sudo. Kør scriptet som Lennart."
[ "$SERVICE_USER" != "root" ] || fail "Kør som din egen bruger med sudo foran, ikke som root."
[ -f "$SCRIPT_DIR/moviebridge.py" ] || fail "moviebridge.py mangler ved siden af install.sh."

info "Tjekker værktøjer"
command -v python3 >/dev/null 2>&1 || fail "python3 mangler. Installér med: sudo apt install python3"
command -v ffmpeg  >/dev/null 2>&1 || fail "ffmpeg mangler. Installér med: sudo apt install ffmpeg"
command -v ffprobe >/dev/null 2>&1 || fail "ffprobe mangler. Installér med: sudo apt install ffmpeg"
PY_OK="$(python3 -c 'import sys; print(1 if sys.version_info >= (3,9) else 0)')"
[ "$PY_OK" = "1" ] || fail "Python 3.9 eller nyere kræves."
if ! ffmpeg -hide_banner -filters 2>/dev/null | grep -q ' subtitles '; then
  info "ADVARSEL: din ffmpeg har ikke undertekst-filteret (libass)."
  info "Undertekster kan ikke brændes ind. Fix: sudo apt install --reinstall ffmpeg"
fi

info "Kører selvtest (det tager et par minutter)"
if ! ( cd "$SCRIPT_DIR" && sudo -u "$SERVICE_USER" env HOME="$(getent passwd "$SERVICE_USER" | cut -d: -f6)" \
        bash -lc "cd '$SCRIPT_DIR' && python3 selftest.py" ); then
  fail "Selvtesten fejlede. Der installeres intet - ret fejlen først."
fi

info "Lægger filerne i $PREFIX"
systemctl stop moviebridge.service 2>/dev/null || true
install -d -m 755 "$PREFIX"
install -m 644 "$SCRIPT_DIR/moviebridge.py" "$PREFIX/moviebridge.py"
install -m 644 "$SCRIPT_DIR/selftest.py" "$PREFIX/selftest.py"
install -m 644 "$SCRIPT_DIR/LAES-MIG.md" "$PREFIX/LAES-MIG.md" 2>/dev/null || true
printf '2.2\n' > "$PREFIX/VERSION"
chmod 755 "$PREFIX"

info "Opretter tjenesten"
cat > "$UNIT" <<EOF
# Managed by MovieBridge installer
[Unit]
Description=MovieBridge - HLS-omvej til Chromecast
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$(id -gn "$SERVICE_USER")
Environment=MB_PORT=$PORT
Environment=MB_DISCOVERY_PORT=8098
Environment=PYTHONUNBUFFERED=1
ExecStart=/usr/bin/env python3 $PREFIX/moviebridge.py
Restart=always
RestartSec=3
NoNewPrivileges=true
PrivateTmp=true
UMask=0022

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable moviebridge.service >/dev/null
systemctl restart moviebridge.service

info "Venter på at tjenesten svarer"
READY=0
for _ in $(seq 1 40); do
  if curl -fsS --max-time 2 "http://127.0.0.1:$PORT/healthz" >/dev/null 2>&1; then READY=1; break; fi
  sleep 0.5
done
if [ "$READY" -ne 1 ]; then
  systemctl --no-pager --lines=25 status moviebridge.service || true
  fail "Tjenesten startede ikke. Se loggen ovenfor."
fi

info "Klar"
printf '  Version : 2.2\n'
printf '  Adresse : http://127.0.0.1:%s/healthz\n' "$PORT"
printf '  Opdagelse: UDP 8098\n'
printf '  Log     : journalctl -u moviebridge -f\n'
printf '\nNæste skridt: åbn MovieBench, cast noget, og se om TV-et bliver ved med at spille.\n'
