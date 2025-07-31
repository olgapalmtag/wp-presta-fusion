#!/bin/bash
set -e

# Intall nginx
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

sudo tee /etc/nginx/sites-available/default >/dev/null <<'EOF'
server {
  listen 80 default_server;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl default_server;
  ssl_certificate     /etc/nginx/ssl/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/tls.key;

  location = /healthz {
    return 200 'OK';
    add_header Content-Type text/plain;
  }

  location / {
    proxy_pass https://k3s_node_private:32443;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_ssl_server_name on;
    proxy_ssl_verify off;
  }

  location /grafana/ {
      proxy_pass http://ip:node/;
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Prefix /grafana;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_read_timeout 180;
  }
}
EOF
