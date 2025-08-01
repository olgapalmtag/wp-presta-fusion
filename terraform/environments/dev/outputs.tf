output "mariadb_endpoint" {
  value = module.mariadb.db_endpoint
}

output "mariadb_port" {
  value = module.mariadb.db_instance_port
}

output "mariadb_name" {
  value = module.mariadb.db_name
}

output "mariadb_username" {
  value     = module.mariadb.db_username
  sensitive = true
}

output "mariadb_password" {
  value     = module.mariadb.db_password
  sensitive = true
}

output "s3_backup_bucket" {
  value = module.s3_backup.bucket_name
}

output "tls_cert" {
  value     = module.tls_certificate.tls_cert
  sensitive = true
}

output "tls_key" {
  value     = module.tls_certificate.tls_key
  sensitive = true
}

output "ec2_instance_public_ip" {
  value = module.ec2.ec2_instance_public_ip
}

output "k3s_public_ip" {
  value = module.ec2.k3s_public_ip
}

output "k3s_private_ip" {
  value = module.ec2.k3s_private_ip
}
