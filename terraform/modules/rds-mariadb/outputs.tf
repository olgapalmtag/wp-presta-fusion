output "mariadb_username" {
  value = var.db_username
}

output "mariadb_password" {
  value = var.db_password
}

output "db_instance_endpoint" {
  value = aws_db_instance.mariadb.endpoint
}

output "db_instance_port" {
  value = aws_db_instance.mariadb.port
}

output "db_name" {
  value = aws_db_instance.mariadb.db_name
}

