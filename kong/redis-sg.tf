# Redis security group
resource "aws_security_group" "redis" {
  description = "Kong redis cluster"
  name        = format("%s-%s-redis", var.service, var.environment)
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      "Name"        = format("%s-%s-redis", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_security_group_rule" "redis-ingress-kong" {
  security_group_id = aws_security_group.redis.id

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "redis-ingress-bastion" {
  security_group_id = aws_security_group.redis.id

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  cidr_blocks = var.bastion_cidr_blocks
}