output "db_endpoint" {
  description = "DNS address of the MariaDB instance"
  value       = aws_db_instance.mariadb.address
}

output "db_instance_port" {
  value = aws_db_instance.mariadb.port
}
output "db_name" {
  description = "Database name"
  value       = aws_db_instance.mariadb.db_name
}

output "db_username" {
  description = "Database user"
  value       = aws_db_instance.mariadb.username
}

output "db_password" {
  description = "Database password"
  value       = aws_db_instance.mariadb.password
}

output "rds_sg_id" {
  description = "Security Group ID der RDS-Instanz"
  value       = aws_security_group.rds_sg.id
}
