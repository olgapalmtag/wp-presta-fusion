resource "aws_db_subnet_group" "mariadb_subnet_group" {
  name       = "mariadb-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "mariadb-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-mariadb-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "MySQL from K3s"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.k3c_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mariadb" {
  identifier        = "${var.project}-mariadb"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mariadb"
  engine_version    = "10.5"
  instance_class    = "db.t3.micro" # AWS Free Tier geeignet

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name
  port     = 3306

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mariadb_subnet_group.name

  backup_retention_period = 7
  backup_window           = "02:00-03:00"

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project}-mariadb-final"

  publicly_accessible = false
  multi_az            = false

  tags = {
    Name = "${var.project}-mariadb"
  }
}

