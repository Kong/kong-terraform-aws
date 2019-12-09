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