locals {
  avaliability_zones = [for s in data.aws_subnet.private_data_subnets : s.availability_zone]
  tags               = merge(var.tags_to_append, { Environment = var.environment })
  vpc_id             = data.aws_subnet.private_data_subnets[0].vpc_id
  db_domain_name     = "postgres.${var.environment}.${data.aws_route53_zone.dns.name}"
}

output "avaliability_zones" {
  value = local.avaliability_zones
}

resource "aws_db_subnet_group" "default" {
  name       = "default_db_subnet_group_postgres_${var.environment}"
  subnet_ids = var.vpc_config_private_data_subnet_ids

  tags = merge(local.tags, { Name = "default_db_subnet_group_postgres_${var.environment}" })
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres_${var.environment}"
  description = "Allow Postgres inbound traffic"
  vpc_id      = data.aws_subnet.private_data_subnets[0].vpc_id

  ingress {
    description = "Allow Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.private_app_subnets : s.cidr_block]
  }

  tags = merge(local.tags, { Name = "allow_postgres_${var.environment}" })
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "auroracluster${var.environment}postgresql"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  database_name           = var.initial_db_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids = [
    aws_security_group.allow_postgres.id
  ]

  scaling_configuration {
    min_capacity = 2
    max_capacity = 2
  }

  tags = merge(local.tags, { Name = "postgres_db_${var.environment}" })
}

resource "aws_route53_record" "database" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = local.db_domain_name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.postgresql.endpoint]
}

output "aws_rds_cluster_postgresql_endpoint" {
  value = local.db_domain_name
}
