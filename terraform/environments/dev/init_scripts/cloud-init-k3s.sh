#!/bin/bash
set -e

echo "Installing K3s with kubeconfig write permissions..."

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

echo "K3s installation complete."

