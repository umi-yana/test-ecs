module "ecs" {
  source       = "../../modules/ecs"
  default_name = local.defult_name
  ecr_image    = var.ecr_image
}

module "ecr" {
  source       = "../../modules/ecr"
  default_name = local.defult_name
}