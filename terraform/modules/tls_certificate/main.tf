resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "main" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.main.private_key_pem

  subjects {
    common_name  = var.common_name
  }

  dns_names       = var.dns_names
  validity_period_hours = 8760
  is_ca_certificate     = false
}

output "tls_cert" {
  value     = tls_self_signed_cert.main.cert_pem
  sensitive = true
}

output "tls_key" {
  value     = tls_private_key.main.private_key_pem
  sensitive = true
}

