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

