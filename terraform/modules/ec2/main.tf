resource "aws_security_group" "instance" {
  name        = "${var.project}-instance-sg"
  description = "Allow HTTP and SSH access to EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-instance-sg"
  }
}

resource "aws_key_pair" "wp_key" {
  key_name   = var.key_name
  public_key = file("wp-presta-key.pub")
}

resource "aws_instance" "cms" {
  ami                    = "ami-0309b5fc16a20deb4"
  instance_type          = "t3.small"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.wp_key.key_name

  user_data                   = var.cms_user_data
  user_data_replace_on_change = true

  tags = {
    Name = "${var.project}-cms-instance"
  }
}

resource "aws_instance" "k3s" {
  ami                    = "ami-0309b5fc16a20deb4"
  instance_type          = "t3.small"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.wp_key.key_name

  user_data                   = var.k3s_user_data
  user_data_replace_on_change = true

  tags = {
    Name = "${var.project}-k3s-instance"
  }
}

resource "aws_security_group" "k3s_node" {
  name        = "${var.project}-k3s-sg"
  description = "Allow EC2/NGINX to reach Traefik NodePort on K3s"
  vpc_id      = var.vpc_id

  # Traefik websecure NodePort (HTTPS 32443) - Quelle ist die EC2/NGINX-SG
  ingress {
    description     = "Traefik websecure NodePort from EC2 NGINX"
    from_port       = 32443
    to_port         = 32443
    protocol        = "tcp"
    security_groups = [aws_security_group.instance.id]
  }

  # Optional: HTTP NodePort (nur für Tests)
  # ingress {
  #   from_port       = 32080
  #   to_port         = 32080
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.instance.id]
  # }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-k3s-sg" }
}
