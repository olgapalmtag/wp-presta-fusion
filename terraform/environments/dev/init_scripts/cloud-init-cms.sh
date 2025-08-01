#!/bin/bash
set -e

# Intall nginx
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

sudo tee /etc/nginx/sites-available/default >/dev/null <<'EOF'
# Redirect HTTP to HTTPS
server {
  listen 80 default_server;
  server_name _;
  return 301 https://$host$request_uri;
}

# ---------- WordPress ----------
server {
  listen 443 ssl;
  server_name wpf.drachenbyte.ddns-ip.net;

  ssl_certificate     /etc/nginx/ssl/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/tls.key;

  location = /healthz {
    return 200 'OK';
    add_header Content-Type text/plain;
  }

  location / {
    proxy_pass https://k3s_private_ip:32443/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_ssl_verify off;
    proxy_ssl_server_name on;
  }
}

# ---------- Grafana ----------
server {
  listen 443 ssl;
  server_name grafana.drachenbyte.ddns-ip.net;

  ssl_certificate     /etc/nginx/ssl/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/tls.key;

  location / {
    proxy_pass https://k3s_private_ip:32443/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_ssl_verify off;
    proxy_ssl_server_name on;
  }
}

EOF
