# Terraform Infrastructure

This Terraform stack provisions the AWS foundation for the example application:
- VPC with public/private subnets, NAT, and routing
- EKS cluster with managed node group
- RDS PostgreSQL (multi-AZ, encrypted, backups enabled)
- ElastiCache Redis
- S3 buckets for application files and backups
- Elastic Container Registry (ECR) repository for application images
- IAM OIDC role for GitHub Actions (short-lived credentials)

## Prerequisites
- Terraform >= 1.5
- AWS account with permissions to create VPC/EKS/RDS/ElastiCache/S3/IAM
- Remote state bucket for backend state
- GitHub repository with Actions OIDC configured

## Notes
- GitHub Actions should pass secrets/variables (e.g., DB password, allowed CIDRs) via `terraform apply -var` flags.
- RDS deletion protection is enabled; disable for ephemeral environments.
- ElastiCache uses encryption in transit/at rest; adjust node class as needed.
