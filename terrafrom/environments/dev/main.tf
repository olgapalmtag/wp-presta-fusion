# VPC Modul
module "vpc" {
  source              = "../../modules/vpc"
  project             = "wp-presta-fusion"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  az                  = "eu-west-3a"
}

# EC2 Modul
module "ec2" {
  source              = "../../modules/ec2"
  project             = "wp-presta-fusion"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_id
  ami_id              = "ami-0c1d144c8fdd8d690" # Ubuntu 20.04 LTS in eu-west-3
  key_name            = "your-aws-keypair-name"

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
}

# ALB Modul
module "alb" {
  source                = "../../modules/alb"
  project               = "wp-presta-fusion"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = [module.vpc.public_subnet_id]
  alb_security_group_id = module.ec2.alb_sg_id
}

