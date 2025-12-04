terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.github_actions_role_arn == null || var.github_actions_role_arn == "" ? [] : [var.github_actions_role_arn]

    content {
      role_arn = assume_role.value
    }
  }
}

