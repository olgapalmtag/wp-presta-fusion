module "tls_certificate" {
  source      = "../../modules/tls_certificate"
  common_name = "drachenbyte.ddns-ip.net"
  dns_names = [
    "wpf.drachenbyte.ddns-ip.net",
    "prestaf.drachenbyte.ddns-ip.net"
  ]
}

# VPC Modul
module "vpc" {
  source                = "../../modules/vpc"
  project               = "wp-presta-fusion"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr_a  = "10.0.1.0/24"
  public_subnet_cidr_b  = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  az_a                  = "eu-west-3a"
  az_b                  = "eu-west-3b"
}

resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP/HTTPS from Internet to ALB"
  vpc_id      = module.vpc.vpc_id

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
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-alb-sg" }
}

# EC2 Modul
module "ec2" {
  source                = "../../modules/ec2"
  project               = "wp-presta-fusion"
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = aws_security_group.alb.id
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  key_name              = "wp-presta-key"
  end_user_username     = var.end_user_username
  end_user_password     = var.end_user_password
  developer_username    = var.developer_username
  developer_password    = var.developer_password
  ops_username          = var.ops_username
  ops_password          = var.ops_password
  sre_username          = var.sre_username
  sre_password          = var.sre_password
  instructor_username   = var.instructor_username
  instructor_password   = var.instructor_password
  k3s_user_data         = file("${path.module}/init_scripts/cloud-init-k3s.sh")
  cms_user_data         = file("${path.module}/init_scripts/cloud-init-cms.sh")
}

# ALB Modul
module "alb" {
  source              = "../../modules/alb"
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = aws_security_group.alb.id
  acm_certificate_arn = var.acm_certificate_arn
}

resource "aws_lb_target_group_attachment" "nginx" {
  target_group_arn = module.alb.target_group_arn
  target_id        = var.nginx_instance_id
  port             = 443
}

# Maria DB

module "mariadb" {
  source            = "../../modules/rds-mariadb"
  project           = "wp-presta-fusion"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.vpc.mariadb_sg_id
  db_name           = "cmsdb"
  db_username       = var.db_username
  db_password       = var.db_password
  k3c_sg_id         = module.k3s.sg_id
}

module "s3_backup" {
  source             = "../../modules/s3-backup"
  backup_bucket_name = "wp-presta-backups"
}
