resource "aws_db_instance" "postgresrds" {
  allocated_storage = var.allocated_storage
  engine = var.engine
  engine_version = var.engine_version
  username = var.username
  password = random_password.database_password.result
  db_name = var.db_name
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  instance_class = var.instance_class
  skip_final_snapshot = true
  identifier = var.identifier
}

resource "random_password" "database_password" {
  length           = 16
  upper            = true
  lower            = true
  numeric          = true
  special          = true
  override_special = "!$%&*"
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.is_public ? var.public_subnet_ids : (var.use_private_internet_access ? var.private_internet_subnet_ids : var.private_subnet_ids)

  tags = {
    Name = "${var.identifier}-db-subnet-group"
  }
}