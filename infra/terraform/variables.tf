variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "task-gitops"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "github_actions_role_arn" {
  description = "IAM Role ARN assumed by GitHub Actions via OIDC"
  type        = string
  default     = null
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "appadmin"
  nullable    = false
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for public ingress (e.g., office IP)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for application images"
  type        = string
  default     = "task-api"
}
