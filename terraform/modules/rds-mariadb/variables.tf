variable "project" {
  description = "Projektname für Resourcenamen"
  type        = string
}

variable "db_name" {
  description = "Name der MariaDB-Datenbank"
  type        = string
}

variable "db_username" {
  description = "Benutzername für die MariaDB"
  type        = string
}

variable "db_password" {
  description = "Passwort für die MariaDB"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnets für die DB Subnet Group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID für die DB"
  type        = string
}

