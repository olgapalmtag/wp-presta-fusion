#!/bin/bash
set -e

# Install K3s with kubeconfig world-readable
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Optional: Warte bis K3s läuft
sleep 30

# Entwickler-Benutzer 'developer' für passwortloses sudo konfigurieren
echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer
chmod 440 /etc/sudoers.d/developer

if [ -f /etc/nginx/ssl/cert.pem ]; then
  chmod 644 /etc/nginx/ssl/cert.pem
else
  echo "Fehler: /etc/nginx/ssl/cert.pem existiert nicht!"
  exit 1
fi

if [ -f /etc/nginx/ssl/tls.key ]; then
  chmod 644 /etc/nginx/ssl/tls.key
else
  echo "Fehler: /etc/nginx/ssl/tls.key existiert nicht!"
  exit 1
fi

