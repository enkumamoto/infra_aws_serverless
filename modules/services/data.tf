data "aws_subnet" "private_app_subnets" {
  count = length(var.vpc_config_private_app_subnet_ids)
  id    = var.vpc_config_private_app_subnet_ids[count.index]
}

data "aws_subnet" "public_subnets" {
  count = length(var.vpc_config_public_subnet_ids)
  id    = var.vpc_config_public_subnet_ids[count.index]
}

# data "aws_ecr_repository" "obsidian-ui" {
#   name = "obsidian/obsidian-ui"
# }

# data "aws_ecr_repository" "obsidian-api" {
#   name = "obsidian/obsidian-api"
# }

# data "aws_ecr_repository" "datapolling" {
#   name = "obsidian/datapolling"
# }

# data "aws_ecr_repository" "keycloak" {
#   name = "obsidian/keycloak"
# }
