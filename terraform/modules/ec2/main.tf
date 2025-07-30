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

  user_data = templatefile("${path.module}/cloud-init.sh", {
    end_user_username   = var.end_user_username
    end_user_password   = var.end_user_password
    developer_username  = var.developer_username
    developer_password  = var.developer_password
    ops_username        = var.ops_username
    ops_password        = var.ops_password
    sre_username        = var.sre_username
    sre_password        = var.sre_password
    instructor_username = var.instructor_username
    instructor_password = var.instructor_password
  })

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

  user_data = file("init_scripts/cloud-init-k3s.sh")

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
