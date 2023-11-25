module "ecr" {
  source       = "../../modules/ecr"
  default_name = local.defult_name
}

module "network" {
  source       = "../../modules/vpc"
  default_name = local.defult_name
}

module "ecs" {
  source             = "../../modules/ecs"
  default_name       = local.defult_name
  ecr_image          = var.ecr_image
  aws_security_group = module.network.security_group_id
  subnet_id          = module.network.subnet_id
}