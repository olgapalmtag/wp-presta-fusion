variable "k8s_host" {
  description = "Kubernetes API Server Endpoint"
  type        = string
}

variable "k8s_token" {
  description = "Kubernetes access token"
  type        = string
}

variable "k8s_ca" {
  description = "Base64 encoded Kubernetes CA certificate"
  type        = string
}

