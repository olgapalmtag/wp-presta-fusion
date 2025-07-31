#!/bin/bash
set -e

# Install K3s
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

chmod 644 /etc/rancher/k3s/k3s.yaml
