#!/bin/bash
set -e

# Install K3s with kubeconfig world-readable
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Optional: Warte bis K3s läuft
sleep 30

# Entwickler-Benutzer 'developer' für passwortloses sudo konfigurieren
echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer
chmod 440 /etc/sudoers.d/developer

