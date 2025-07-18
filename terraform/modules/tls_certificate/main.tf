resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "main" {
  private_key_pem        = tls_private_key.main.private_key_pem
  validity_period_hours  = 8760
  early_renewal_hours    = 720

  subject {
    common_name  = "drachenbyte.ddns-ip.net"
    organization = "WpPrestaFusion"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
output "tls_cert" {
  value     = tls_self_signed_cert.main.cert_pem
  sensitive = true
}

output "tls_key" {
  value     = tls_private_key.main.private_key_pem
  sensitive = true
}

