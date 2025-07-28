#!/bin/bash
set -e

# Installiere Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o get-helm.sh
chmod +x get-helm.sh
./get-helm.sh

# Prometheus + Grafana über Helm installieren
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace

