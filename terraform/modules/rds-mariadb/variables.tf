variable "project" {
  type        = string
  description = "Project prefix for naming resources"
}

variable "db_username" {
  type        = string
  description = "DB username"
}

variable "db_password" {
  type        = string
  description = "DB password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID allowing access to MariaDB"
}

variable "port" {
  description = "Port for MariaDB"
  type        = number
  default     = 3306
}

