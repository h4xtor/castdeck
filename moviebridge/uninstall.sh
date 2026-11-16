#!/usr/bin/env bash
# Fjerner MovieBridge fra X280.  Brug:  sudo bash uninstall.sh
set -u
[ "$(id -u)" -ne 0 ] && exec sudo bash "$0" "$@"
systemctl disable --now moviebridge 2>/dev/null
rm -f /etc/systemd/system/moviebridge.service
systemctl daemon-reload
rm -rf /opt/moviebridge /var/cache/moviebridge /var/cache/private/moviebridge
echo "MovieBridge er fjernet. (ffmpeg og python er ladet blive)"
