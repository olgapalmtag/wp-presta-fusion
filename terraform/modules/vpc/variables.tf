variable "project" {
  description = "Project name used for resource tags"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B"
  type        = string
}

variable "az_a" {
  default = "eu-west-3a"
}

variable "az_b" {
  default = "eu-west-3b"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
