variable "project" {
  description = "Project name used for resource tags"
  type        = string
}

public_subnet_cidr_a  = "10.0.1.0/24"
public_subnet_cidr_b  = "10.0.2.0/24"
private_subnet_cidr_a = "10.0.3.0/24"
private_subnet_cidr_b = "10.0.4.0/24"

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

