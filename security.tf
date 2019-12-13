# PostgreSQL security group
resource "aws_security_group" "postgresql" {
  description = "Kong RDS instance"
  name        = format("%s-%s-postgresql", var.service, var.environment)
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      "Name"        = format("%s-%s-postgresql", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_security_group_rule" "postgresql-ingress-kong" {
  security_group_id = aws_security_group.postgresql.id

  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "postgresql-ingress-bastion" {
  security_group_id = aws_security_group.postgresql.id

  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  cidr_blocks = var.bastion_cidr_blocks
}

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

# Kong node security group and rules
resource "aws_security_group" "kong" {
  description = "Kong EC2 instances"
  name        = format("%s-%s", var.service, var.environment)
  vpc_id      = data.aws_vpc.vpc.id

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

resource "aws_security_group_rule" "admin-ingress-bastion" {
  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8001
  to_port   = 8001
  protocol  = "tcp"

  cidr_blocks = var.bastion_cidr_blocks
}

# External load balancer access
resource "aws_security_group_rule" "proxy-ingress-external-lb" {
  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8000
  to_port   = 8000
  protocol  = "tcp"

  source_security_group_id = aws_security_group.external-lb.id
}

resource "aws_security_group_rule" "admin-ingress-external-lb" {
  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8001
  to_port   = 8001
  protocol  = "tcp"

  source_security_group_id = aws_security_group.external-lb.id
}

# Internal load balancer access
resource "aws_security_group_rule" "proxy-ingress-internal-lb" {
  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8000
  to_port   = 8000
  protocol  = "tcp"

  source_security_group_id = aws_security_group.internal-lb.id
}

resource "aws_security_group_rule" "admin-ingress-internal-lb" {
  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8001
  to_port   = 8001
  protocol  = "tcp"

  source_security_group_id = aws_security_group.internal-lb.id
}

resource "aws_security_group_rule" "manager-ingress-internal-lb" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8002
  to_port   = 8002
  protocol  = "tcp"

  source_security_group_id = aws_security_group.internal-lb.id
}

resource "aws_security_group_rule" "portal-gui-ingress-internal-lb" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8003
  to_port   = 8003
  protocol  = "tcp"

  source_security_group_id = aws_security_group.internal-lb.id
}

resource "aws_security_group_rule" "portal-ingress-internal-lb" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.kong.id

  type      = "ingress"
  from_port = 8004
  to_port   = 8004
  protocol  = "tcp"

  source_security_group_id = aws_security_group.internal-lb.id
}

# HTTP outbound for Debian packages
resource "aws_security_group_rule" "kong-egress-http" {
  security_group_id = aws_security_group.kong.id

  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# HTTPS outbound for awscli, kong
resource "aws_security_group_rule" "kong-egress-https" {
  security_group_id = aws_security_group.kong.id

  type      = "egress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# Load balancers
# External
resource "aws_security_group" "external-lb" {
  description = "Kong External Load Balancer"
  name        = format("%s-%s-external-lb", var.service, var.environment)
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      "Name"        = format("%s-%s-external-lb", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_security_group_rule" "external-lb-ingress-proxy" {
  security_group_id = aws_security_group.external-lb.id

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = var.external_cidr_blocks
}

resource "aws_security_group_rule" "external-lb-egress-proxy" {
  security_group_id = aws_security_group.external-lb.id

  type      = "egress"
  from_port = 8000
  to_port   = 8000
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "external-lb-egress-admin" {
  security_group_id = aws_security_group.external-lb.id

  type      = "egress"
  from_port = 8001
  to_port   = 8001
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

# Internal
resource "aws_security_group" "internal-lb" {
  description = "Kong Internal Load Balancer"
  name        = format("%s-%s-internal-lb", var.service, var.environment)
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      "Name"        = format("%s-%s-internal-lb", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_security_group_rule" "internal-lb-ingress-proxy-http" {
  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = var.internal_http_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-ingress-proxy-https" {
  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = var.internal_https_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-ingress-admin" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 8444
  to_port   = 8444
  protocol  = "tcp"

  cidr_blocks = var.admin_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-ingress-manager" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 8445
  to_port   = 8445
  protocol  = "tcp"

  cidr_blocks = var.manager_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-ingress-portal-gui" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 8446
  to_port   = 8446
  protocol  = "tcp"

  cidr_blocks = var.portal_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-ingress-portal" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "ingress"
  from_port = 8447
  to_port   = 8447
  protocol  = "tcp"

  cidr_blocks = var.portal_cidr_blocks
}

resource "aws_security_group_rule" "internal-lb-egress-proxy" {
  security_group_id = aws_security_group.internal-lb.id

  type      = "egress"
  from_port = 8000
  to_port   = 8000
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "internal-lb-egress-admin" {
  security_group_id = aws_security_group.internal-lb.id

  type      = "egress"
  from_port = 8001
  to_port   = 8001
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "internal-lb-egress-manager" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "egress"
  from_port = 8002
  to_port   = 8002
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "internal-lb-egress-portal-gui" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "egress"
  from_port = 8003
  to_port   = 8003
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}

resource "aws_security_group_rule" "internal-lb-egress-portal" {
  count = var.enable_ee ? 1 : 0

  security_group_id = aws_security_group.internal-lb.id

  type      = "egress"
  from_port = 8004
  to_port   = 8004
  protocol  = "tcp"

  source_security_group_id = aws_security_group.kong.id
}
