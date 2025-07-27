provider "kubernetes" {
  host                   = module.wordpress_k8s.k8s_host
  token                  = module.wordpress_k8s.k8s_token
  cluster_ca_certificate = base64decode(module.wordpress_k8s.k8s_ca)
}

