variable "project_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "security_groups" { type = list(string) }

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-redis-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis" {
  name        = "${var.project_name}-redis-sg"
  description = "Redis access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.project_name}-redis"
  description                   = "Redis for ${var.project_name}"
  engine                        = "redis"
  engine_version                = "7.0"
  node_type                     = "cache.t3.micro"
  num_cache_clusters            = 1
  automatic_failover_enabled    = false
  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = true
  security_group_ids            = [aws_security_group.redis.id]
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  maintenance_window            = "sun:05:00-sun:09:00"
}
