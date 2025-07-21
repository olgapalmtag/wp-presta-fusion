output "mariadb_endpoint" {
  value = module.mariadb.db_instance_endpoint
}

output "mariadb_db_name" {
  value = module.mariadb.db_name
}

output "mariadb_port" {
  value = module.mariadb.db_instance_port
}

output "s3_backup_bucket" {
  value = module.s3_backup.bucket_name
}

