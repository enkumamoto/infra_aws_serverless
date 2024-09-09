locals {
  tags_to_append = {
    "Environment" = var.environment
  }
}

module "networking" {
  source         = "./modules/networking"
  environment    = var.environment
  tags_to_append = local.tags_to_append
  region         = var.region
  dns_zone_name  = var.dns_zone_name
}

# output "nameserver_data" {
#   value = {
#     name = var.dns_zone_name
#     NS   = module.networking.nameserver
#   }
# }

data "aws_security_group" "default" {
  vpc_id = module.networking.vpc_id
  name   = "default"
}

module "ecs_cluster" {
  source         = "./modules/ecs_cluster"
  environment    = var.environment
  tags_to_append = local.tags_to_append

  vpc_config_public_subnet_ids = module.networking.public_subnet_ids
  dns_zone_name                = var.dns_zone_name
  aws_acm_certificate_arn      = module.networking.aws_acm_certificate_arn

  depends_on = [module.networking]
}

module "ingestion" {
  source                               = "./modules/ingestion-http"
  environment                          = var.environment
  tags_to_append                       = local.tags_to_append
  region                               = var.region
  lambda_vpc_config_subnet_ids         = module.networking.private_app_subnet_ids
  lambda_vpc_config_security_group_ids = [data.aws_security_group.default.id]
  dns_zone_name                        = var.dns_zone_name
  # aws_acm_certificate_arn              = module.networking.aws_acm_certificate_arn
}

output "ingestion_data" {
  value = {
    ecr_repository_uri = module.ingestion.container_registry_url
    lambda_arn         = module.ingestion.lambda_arn
    # ingestion_test_v2  = module.ingestion.test_v2_cURL
  }
}

module "database" {
  source         = "./modules/database"
  environment    = var.environment
  tags_to_append = local.tags_to_append
  region         = var.region

  vpc_config_private_app_subnet_ids  = module.networking.private_app_subnet_ids
  vpc_config_private_data_subnet_ids = module.networking.private_data_subnet_ids
  dns_zone_name                      = var.dns_zone_name

  initial_db_name = var.initial_db_name
  master_username = var.master_username
  master_password = var.master_password

  depends_on = [module.networking]
}

output "database_endpoint" {
  value = module.database.aws_rds_cluster_postgresql_endpoint
}

module "frontend" {
  source                  = "./modules/frontend"
  environment             = var.environment
  tags_to_append          = local.tags_to_append
  dns_zone_name           = var.dns_zone_name
  aws_acm_certificate_arn = module.networking.aws_acm_certificate_arn

  depends_on = [module.networking]
}

output "frontend_data" {
  value = {
    frontend_url        = module.frontend.frontend_url
    cdn_distribution_id = module.frontend.cdn_distribution_id
    bucket_name         = module.frontend.bucket_name
  }
}
