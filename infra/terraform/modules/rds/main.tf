variable "project_name" { type = string }
variable "db_username" {
  type     = string
  default  = "appadmin"
  nullable = false

  validation {
    condition     = length(trimspace(var.db_username)) > 0
    error_message = "db_username must be a non-empty string."
  }
}
variable "db_password" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "security_groups" { type = list(string) }
variable "allocated_storage" { type = number }

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-rds-subnet-${replace(var.vpc_id, "vpc-", "")}" 
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Postgres access from EKS nodes"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-postgres"
  allocated_storage       = var.allocated_storage
  engine                  = "postgres"
  engine_version          = "18.1"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  multi_az                = true
  backup_retention_period = 7
  delete_automated_backups = true
  skip_final_snapshot      = true
  deletion_protection      = false
  storage_encrypted       = true
  auto_minor_version_upgrade = true
}
