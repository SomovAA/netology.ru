module "vpc" {
  source  = "hamnsk/vpc/yandex"
  version = "0.5.0"
  description = "vpc yandex by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  yc_folder_id = var.yc_folder_id
  name = "test"
  subnets = local.vpc_subnets
}