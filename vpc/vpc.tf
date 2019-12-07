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

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.private_subnet1_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
  tags = {
    Name        = format("Private-Subnet-1-%s-%s", var.service, var.environment),
    description = "Kong Private Subnet 1",
    Environment = var.environment,
    Service     = var.service,
    Tier        = "private"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.private_subnet2_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneB
  tags = {
    Name        = format("Private-Subnet-2-%s-%s", var.service, var.environment),
    description = "Kong Private Subnet 2",
    Environment = var.environment,
    Service     = var.service,
    Tier        = "private"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
  tags = {
    Name        = format("Public-Subnet-%s-%s", var.service, var.environment),
    description = "Kong Public Subnet",
    Environment = var.environment,
    Service     = var.service,
    Tier        = "public"
  }
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.db_subnet1_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
  tags = {
    Name        = format("DB-Subnet-1-%s-%s", var.service, var.environment),
    description = "DB Subnet 1",
    Environment = var.environment,
    Service     = var.service
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.db_subnet2_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneB
  tags = {
    Name        = format("DB-Subnet-2-%s-%s", var.service, var.environment),
    description = "DB Subnet 2",
    Environment = var.environment,
    Service     = var.service
  }
}

resource "aws_db_subnet_group" "k_db_subnet_group" {
  name       = "k_db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_subnet" "cache_subnet" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.cache_subnet_cidr
  map_public_ip_on_launch = var.mapPublicIP
  #availability_zone       = var.availabilityZoneA
  tags = {
    Name        = format("Cache-Subnet-%s-%s", var.service, var.environment),
    description = "Cache Subnet",
    Environment = var.environment,
    Service     = var.service
  }
}

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
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   # change this to only allow access from mgmt instance
  #   cidr_blocks = [var.ingressCIDRblock]
  # }
 
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