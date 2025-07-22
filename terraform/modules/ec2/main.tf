resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP access to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.project}-instance-sg"
  description = "Allow HTTP access to EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
  instance_type          = "t2.micro"
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
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.wp_key.key_name

  user_data = templatefile("${path.module}/cloud-init-k3s.sh.tpl", {
    developer_username = var.developer_username
    developer_password = var.developer_password
  })

  tags = {
    Name = "${var.project}-k3s-instance"
  }
}

