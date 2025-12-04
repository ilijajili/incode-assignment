terraform {
  backend "s3" {
    key     = "eks-gitops/terraform.tfstate"
    encrypt = true
  }
}
