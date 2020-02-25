resource "aws_elasticache_replication_group" "kong" {
  count = var.enable_redis ? 1 : 0

  replication_group_id          = format("%s-%s", var.service, var.environment)
  replication_group_description = var.description

  engine                = "redis"
  engine_version        = var.redis_engine_version
  node_type             = var.redis_instance_type
  number_cache_clusters = var.redis_instance_count
  parameter_group_name  = format("%s-%s", var.service, var.environment)
  port                  = 6379

  subnet_group_name  = var.redis_subnets
  security_group_ids = [aws_security_group.redis.id]

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
  depends_on = [aws_elasticache_parameter_group.kong]
}

resource "aws_elasticache_parameter_group" "kong" {
  name   = format("%s-%s", var.service, var.environment)
  family = var.redis_family

  description = var.description
}
