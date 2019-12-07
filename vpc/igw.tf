resource "aws_internet_gateway" "kong_igw" {
  vpc_id = aws_vpc.kong_vpc.id

  tags = {
    Name        = format("VPC-GW-%s-%s", var.service, var.environment),
    Environment = var.environment,
    Service     = var.service
  }
}

resource "aws_route_table" "gateway_routetable" {
  vpc_id = aws_vpc.kong_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kong_igw.id
  }

  tags = {
    Name = "gateway_routetable-1"
  }
}

resource "aws_route_table_association" "subnet_route_table_association-1-a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.gateway_routetable.id
}
