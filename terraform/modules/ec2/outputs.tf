output "ec2_instance_public_ip" {
  value = aws_instance.cms.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.cms.id
}

output "k3s_instance_id" {
  value = aws_instance.k3s.id
}

output "kubeconfig_path_on_instance" {
  value = "/home/${var.developer_username}/.kube/config"
}

output "k3s_public_ip" {
  description = "Public IP of the K3s EC2 instance"
  value       = aws_instance.k3s.public_ip
}

output "k3s_private_ip" {
  description = "Private IP of the K3s EC2 instance"
  value       = aws_instance.k3s.private_ip
}
