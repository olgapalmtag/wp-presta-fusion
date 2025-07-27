variable "end_user_username" {
  description = "Username for end user"
  type        = string
}

variable "end_user_password" {
  description = "Password for end user"
  type        = string
}

variable "developer_username" {
  description = "Username for developer"
  type        = string
}

variable "developer_password" {
  description = "Password for developer"
  type        = string
}

variable "ops_username" {
  description = "Username for operations user"
  type        = string
}

variable "ops_password" {
  description = "Password for operations user"
  type        = string
}

variable "sre_username" {
  description = "Username for SRE"
  type        = string
}

variable "sre_password" {
  description = "Password for SRE"
  type        = string
}

variable "instructor_username" {
  description = "Username for instructor"
  type        = string
}

variable "instructor_password" {
  description = "Password for instructor"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-3" # Paris (Free Tier eligible)

}

variable "db_username" {}
variable "db_password" {
  sensitive = true
}

variable "ssh_key_path" {
  description = "Pfad zum SSH Private Key für EC2 Zugriff"
  type        = string
}

