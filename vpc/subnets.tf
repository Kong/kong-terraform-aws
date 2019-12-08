resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.private_subnet1_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneA
  depends_on              = [aws_internet_gateway.kong_igw]
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
  depends_on              = [aws_internet_gateway.kong_igw]
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
  depends_on              = [aws_internet_gateway.kong_igw]
  tags = {
    Name        = format("Public-Subnet-1-%s-%s", var.service, var.environment),
    description = "Kong Public Subnet 1",
    Environment = var.environment,
    Service     = var.service,
    Tier        = "public"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.kong_vpc.id
  cidr_block              = var.public_subnet2_cidr
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZoneB
  depends_on              = [aws_internet_gateway.kong_igw]
  tags = {
    Name        = format("Public-Subnet-2-%s-%s", var.service, var.environment),
    description = "Kong Public Subnet 2",
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