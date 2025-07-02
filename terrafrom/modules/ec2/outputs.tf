output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.cms.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.cms.id
}

output "k3s_instance_public_ip" {
  value = aws_instance.k3s.public_ip
}

output "kubeconfig_path_on_instance" {
  value = "/home/${var.developer_username}/.kube/config"
}
