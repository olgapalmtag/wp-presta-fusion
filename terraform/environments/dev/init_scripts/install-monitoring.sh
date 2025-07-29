#!/bin/bash
set -e

# Set KUBECONFIG path for K3s
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install Helm (only if not already installed)
if ! command -v helm >/dev/null 2>&1; then
  echo "Installing Helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o get-helm.sh
  chmod +x get-helm.sh
  ./get-helm.sh
else
  echo "Helm is already installed."
fi

# Add Helm repo for kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace if not existing
kubectl get namespace monitoring >/dev/null 2>&1 || kubectl create namespace monitoring

# Install or upgrade kube-prometheus-stack
for i in {1..3}; do
  echo "Installing kube-prometheus-stack (attempt $i)..."
  helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
    --namespace monitoring --create-namespace \
    --set grafana.adminPassword=prom-operator \
    --set grafana.service.type=NodePort \
    --set prometheus.service.type=NodePort \
    --set alertmanager.service.type=NodePort \
  echo "Helm install failed. Retrying in 10 seconds..."
  sleep 10
done
