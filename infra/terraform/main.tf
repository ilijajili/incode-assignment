module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  cluster_version    = "1.29"
  subnet_ids         = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
  vpc_id             = module.network.vpc_id
  node_desired_size  = 2
  node_max_size      = 4
  node_min_size      = 2
}

module "rds" {
  source           = "./modules/rds"
  project_name     = var.project_name
  db_username      = var.db_username
  db_password      = var.db_password
  subnet_ids       = module.network.private_subnet_ids
  vpc_id           = module.network.vpc_id
  security_groups  = [module.eks.node_security_group_id]
  allocated_storage = 20
}

module "redis" {
  source       = "./modules/redis"
  project_name = var.project_name
  subnet_ids   = module.network.private_subnet_ids
  vpc_id       = module.network.vpc_id
  security_groups = [module.eks.node_security_group_id]
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "ecr" {
  source           = "./modules/ecr"
  repository_name  = var.ecr_repository_name
}
