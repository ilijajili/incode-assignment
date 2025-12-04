terraform {
  backend "s3" {
    key     = "infra/terraform/terraform.tfstate"
    encrypt = true
  }
}
