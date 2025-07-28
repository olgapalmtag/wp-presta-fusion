variable "project" {
  description = "Project name used for tagging resources"
  type        = string
}

variable "end_user_username" {
  type        = string
  description = "Username for the CMS end user"
}

variable "end_user_password" {
  type        = string
  description = "Password for the CMS end user"
  sensitive   = true
}

variable "developer_username" {
  type        = string
  description = "Username for the Developer"
}

variable "developer_password" {
  type        = string
  description = "Password for the Developer"
  sensitive   = true
}

variable "ops_username" {
  type        = string
  description = "Username for the Operations Engineer"
}

variable "ops_password" {
  type        = string
  description = "Password for the Operations Engineer"
  sensitive   = true
}

variable "sre_username" {
  type        = string
  description = "Username for the Site Reliability Engineer"
}

variable "sre_password" {
  type        = string
  description = "Password for the Site Reliability Engineer"
  sensitive   = true
}

variable "instructor_username" {
  type        = string
  description = "Username for the Instructor/Trainer"
}

variable "instructor_password" {
  type        = string
  description = "Password for the Instructor/Trainer"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the EC2 and ALB SG should be created"
}

variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet for the EC2 instance"
}

variable "alb_security_group_id" {
  description = "Security Group ID of the ALB to allow HTTPS"
  type        = string
}

variable "key_name" {
  type        = string
  description = "Name of the existing EC2 key pair for SSH access"
}
