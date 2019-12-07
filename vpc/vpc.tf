resource "aws_vpc" "kong_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name        = format("VPC-%s-%s", var.service, var.environment),
    Environment = var.environment,
    Service     = var.service,
  }
}

# vpc sg
resource "aws_security_group" "kong_vpc_sg" {
  vpc_id      = aws_vpc.kong_vpc.id
  name        = "kong_vpc_sg"
  description = "VPC level security group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # verify the cidr blocks?? why we need subnet cidr for VPC ingress
    # allw traffic only from LB
    # if this is common for NAT then define seperate SG for NAT
    cidr_blocks = [var.vpc_ingress_cidr]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # verify the cidr blocks?? why we need subnet cidr for VPC ingress
    # allw traffic only from LB
    cidr_blocks = [var.vpc_ingress_cidr]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # change this to only allow access from mgmt instance
    cidr_blocks = [var.vpc_ingress_cidr]
  }
 
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_egress_cidr]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_egress_cidr]
  }
  # egress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.vpcCIDRblock]
  # }
  
  tags = {
    Name        = format("VPC-SG-%s-%s", var.service, var.environment),
    Environment = var.environment,
    Service     = var.service
  }
} # end resource