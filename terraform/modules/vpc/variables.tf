variable "project" {
  description = "Project name used for resource tags"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "az_a" {
  default = "eu-west-3a"
}

variable "az_b" {
  default = "eu-west-3b"
}

