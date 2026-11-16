#!/usr/bin/env bash
# MovieBridge - installation paa X280 (Linux Mint/Ubuntu/Debian eller Arch/Omarchy)
# Brug:  sudo bash install.sh
set -euo pipefail

APP_DIR=/opt/moviebridge
UNIT=/etc/systemd/system/moviebridge.service
PORT=8097
DISC_PORT=8098
NO_SERVICE=0
[ "${1:-}" = "--no-service" ] && NO_SERVICE=1   # kun til test
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ok()   { printf '\033[32m[OK]\033[0m %s\n' "$*"; }
info() { printf '\033[36m[..]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[!!]\033[0m %s\n' "$*"; }
die()  { printf '\033[31m[FEJL]\033[0m %s\n' "$*"; exit 1; }

if [ "$(id -u)" -ne 0 ]; then
  exec sudo bash "$0" "$@"
fi
[ -f "$HERE/moviebridge.py" ] || die "moviebridge.py mangler ved siden af install.sh"

# 1) Pakker
info "Installerer ffmpeg og Python ..."
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get install -y -qq ffmpeg python3 python3-venv curl >/dev/null
elif command -v pacman >/dev/null 2>&1; then
  pacman -Sy --needed --noconfirm ffmpeg python curl >/dev/null
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y -q ffmpeg python3 curl >/dev/null || warn "ffmpeg kan kraeve RPM Fusion paa Fedora"
else
  warn "Ukendt Linux - soerg selv for ffmpeg og python3"
fi
command -v ffmpeg >/dev/null || die "ffmpeg blev ikke installeret"
command -v python3 >/dev/null || die "python3 blev ikke installeret"
ok "ffmpeg $(ffmpeg -version | head -1 | awk '{print $3}') og $(python3 --version)"

# 2) Programmet
info "Kopierer MovieBridge til $APP_DIR ..."
mkdir -p "$APP_DIR"
install -m 0755 "$HERE/moviebridge.py" "$APP_DIR/moviebridge.py"
if [ ! -x "$APP_DIR/venv/bin/python" ]; then
  python3 -m venv "$APP_DIR/venv" || die "kunne ikke lave Python-venv"
fi
info "Installerer TV-styring (pychromecast) ..."
if "$APP_DIR/venv/bin/pip" install -q --upgrade pip >/dev/null 2>&1 && \
   "$APP_DIR/venv/bin/pip" install -q "pychromecast>=14" >/dev/null 2>&1; then
  ok "pychromecast installeret (web-siden kan sende direkte til TV)"
else
  warn "pychromecast kunne ikke installeres - appen virker stadig, kun web-sidens 'Send til TV' mangler"
fi
"$APP_DIR/venv/bin/python" -m py_compile "$APP_DIR/moviebridge.py" || die "programfilen er beskadiget"

info "Selvtest: henter og omdanner en falsk stump-stream paa denne maskine ..."
set +e
ST_OUT=$(MB_WORK=/tmp "$APP_DIR/venv/bin/python" "$APP_DIR/moviebridge.py" --selftest 2>&1)
ST_RC=$?
set -e
printf '%s\n' "$ST_OUT" | grep -E '^SELVTEST|^   ' || true
if [ "$ST_RC" -eq 0 ]; then
  ok "Selvtest bestaaet - ffmpeg og stump-hentning virker her"
else
  warn "SELVTEST FEJLEDE - send mig linjerne ovenfor (de der starter med SELVTEST)"
fi

if [ "$NO_SERVICE" = 1 ]; then ok "Testinstallation faerdig (ingen tjeneste)"; exit 0; fi

# 3) Tjeneste der starter af sig selv og koerer 24/7
info "Opretter tjenesten moviebridge ..."
cat > "$UNIT" <<EOF
[Unit]
Description=MovieBridge - stream-oversaetter til Chromecast/Android TV
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=$APP_DIR/venv/bin/python $APP_DIR/moviebridge.py
Environment=MB_PORT=$PORT
Environment=MB_DISCOVERY_PORT=$DISC_PORT
Environment=MB_ENCODER=x264
Environment=PYTHONUNBUFFERED=1
DynamicUser=yes
CacheDirectory=moviebridge
Restart=always
RestartSec=3
Nice=5

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now moviebridge >/dev/null 2>&1
systemctl restart moviebridge

# 4) Firewall (kun hvis en er slaaet til)
if command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -q "Status: active"; then
  ufw allow $PORT/tcp >/dev/null; ufw allow $DISC_PORT/udp >/dev/null; ufw allow 5353/udp >/dev/null
  ok "ufw: aabnet $PORT/tcp, $DISC_PORT/udp og 5353/udp"
fi
if command -v firewall-cmd >/dev/null 2>&1 && firewall-cmd --state >/dev/null 2>&1; then
  firewall-cmd -q --permanent --add-port=$PORT/tcp --add-port=$DISC_PORT/udp --add-service=mdns
  firewall-cmd -q --reload
  ok "firewalld: aabnet porte"
fi

# 5) Tjek at den svarer
for i in $(seq 1 20); do
  curl -fs "http://127.0.0.1:$PORT/health" >/dev/null 2>&1 && break
  sleep 0.5
done
if curl -fs "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
  IP=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')
  echo
  ok "MovieBridge koerer og starter selv ved genstart."
  echo "    Web-side:  http://${IP:-<X280-IP>}:$PORT"
  echo "    Log:       journalctl -u moviebridge -f"
  echo "    Stop:      sudo systemctl stop moviebridge"
else
  warn "Tjenesten svarer ikke endnu. Se:  journalctl -u moviebridge -n 50"
  exit 1
fi
