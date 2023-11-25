module "ecr" {
  source       = "../../modules/ecr"
  default_name = local.defult_name
}

module "network" {
  source       = "../../modules/vpc"
  default_name = local.defult_name
}

module "security_group" {
  source       = "../../modules/security_group"
  default_name = local.defult_name
  vpc_id       = module.network.vpc_id
}

module "ecs" {
  source            = "../../modules/ecs"
  default_name      = local.defult_name
  ecr_image         = var.ecr_image
  security_group_id = module.security_group.security_group_id
  subnet_id         = module.network.private-subnet-1
}

