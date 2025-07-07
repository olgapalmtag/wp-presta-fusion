#!/bin/bash
# cloud-init script for K3s master installation with dev + ops users

useradd -m ${developer_username}
echo "${developer_username}:${developer_password}" | chpasswd

curl -sfL https://get.k3s.io | sh -

mkdir -p /home/${developer_username}/.kube
cp /etc/rancher/k3s/k3s.yaml /home/${developer_username}/.kube/config
chown ${developer_username}:${developer_username} /home/${developer_username}/.kube/config

