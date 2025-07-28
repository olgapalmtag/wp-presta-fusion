#!/bin/bash
set -e

# Install K3s
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Warte kurz bis K3s ready ist
sleep 30

# Entwickler-Benutzer für passwortloses sudo
echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer
chmod 440 /etc/sudoers.d/developer


