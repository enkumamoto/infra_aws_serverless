data "aws_subnet" "private_app_subnets" {
  count = length(var.vpc_config_private_app_subnet_ids)
  id    = var.vpc_config_private_app_subnet_ids[count.index]
}

data "aws_subnet" "public_subnets" {
  count = length(var.vpc_config_public_subnet_ids)
  id    = var.vpc_config_public_subnet_ids[count.index]
}

# data "aws_ecr_repository" "blackstone-ui" {
#   name = "blackstone/blackstone-ui"
# }

# data "aws_ecr_repository" "blackstone-api" {
#   name = "blackstone/blackstone-api"
# }

# data "aws_ecr_repository" "datapolling" {
#   name = "blackstone/datapolling"
# }

# data "aws_ecr_repository" "keycloak" {
#   name = "blackstone/keycloak"
# }
