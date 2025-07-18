resource "aws_db_subnet_group" "mariadb_subnet_group" {
  name       = "mariadb-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "mariadb-subnet-group"
  }
}
resource "aws_db_instance" "mariadb" {
  identifier             = "${var.project}-mariadb"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.5"
  instance_class         = "db.t3.micro" # Free Tier
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  port                   = 3306
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.mariadb_subnet_group.name
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

  tags = {
    Name = "${var.project}-mariadb"
  }
}

