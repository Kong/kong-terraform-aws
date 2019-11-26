resource "aws_rds_cluster" "kong" {
  count = var.enable_aurora && var.db_instance_count > 0 ? 1 : 0

  cluster_identifier = format("%s-%s", var.service, var.environment)
  engine             = "aurora-postgresql"
  engine_version     = var.db_engine_version
  engine_mode        = var.db_engine_mode
  master_username    = var.db_username
  master_password    = random_string.master_password.result

  backup_retention_period         = var.db_backup_retention_period
  db_subnet_group_name            = var.db_subnets
  db_cluster_parameter_group_name = format("%s-%s-cluster", var.service, var.environment)

  vpc_security_group_ids = [aws_security_group.postgresql.id]

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "kong" {
  count = var.enable_aurora ? var.db_instance_count : 0

  identifier         = format("%s-%s-%s", var.service, var.environment, count.index)
  cluster_identifier = aws_rds_cluster.kong[0].id
  engine             = "aurora-postgresql"
  engine_version     = var.db_engine_version
  instance_class     = var.db_instance_class

  db_subnet_group_name    = var.db_subnets
  db_parameter_group_name = format("%s-%s", var.service, var.environment)

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_rds_cluster_parameter_group" "kong" {
  count = var.enable_aurora && var.db_instance_count > 0 ? 1 : 0

  name        = format("%s-%s-cluster", var.service, var.environment)
  family      = var.db_family
  description = var.description

  tags = merge(
    {
      "Name"        = format("%s-%s-cluster", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

