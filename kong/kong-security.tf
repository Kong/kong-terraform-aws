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