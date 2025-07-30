variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB is deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB placement"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM TLS certificate for HTTPS listener"
  type        = string
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID to attach to the ALB"
}

variable "healthcheck_path" {
  type    = string
  default = "/healthz"
}
