module "nginx_ecs_service" {
  source                  = "./modules/ecs_service"
  environment             = var.environment
  tags_to_append          = local.tags_to_append
  service_identifier      = "nginx-example" # Add the missing service_identifier attribute
  service_container_name  = "nginx"
  service_container_image = "nginx:alpine"

  service_lb_entries = [
    {
      port                 = 80
      host_prefix          = "nginx"
      path_pattern         = "/*"
      health_check_matcher = "200"
      health_check_path    = "/"
    },
  ]

  vpc_config_private_app_subnet_ids = module.networking.private_app_subnet_ids
  vpc_config_public_subnet_ids      = module.networking.public_subnet_ids
  alb_listener_arn                  = module.ecs_cluster.alb_listener_arn
  ecs_cluster_id                    = module.ecs_cluster.ecs_cluster_id
  dns_zone_name                     = var.dns_zone_name

  depends_on = [module.networking, module.ecs_cluster]
}

output "nginx_service_url" {
  value = module.nginx_ecs_service.microservice_url
}

module "adminer_ecs_service" {
  source                  = "./modules/ecs_service"
  environment             = var.environment
  tags_to_append          = local.tags_to_append
  service_identifier      = "adminer" # Add the missing service_identifier attribute
  service_container_name  = "adminer"
  service_container_image = "adminer:latest"

  service_lb_entries = [
    {
      port                 = 8080
      host_prefix          = "adminer"
      path_pattern         = "/*"
      health_check_matcher = "200"
      health_check_path    = "/"
    },
  ]

  vpc_config_private_app_subnet_ids = module.networking.private_app_subnet_ids
  vpc_config_public_subnet_ids      = module.networking.public_subnet_ids
  alb_listener_arn                  = module.ecs_cluster.alb_listener_arn
  ecs_cluster_id                    = module.ecs_cluster.ecs_cluster_id
  dns_zone_name                     = var.dns_zone_name

  depends_on = [module.networking, module.ecs_cluster]
}

output "adminer_service_url" {
  value = module.adminer_ecs_service.microservice_url
}
