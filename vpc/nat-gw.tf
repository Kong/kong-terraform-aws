resource "aws_eip" "kong_vpc_eip" {
  vpc = true
}

resource "aws_nat_gateway" "kong_vpc_nat_gw" {
  allocation_id = aws_eip.kong_vpc_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.kong_igw]
}

resource "aws_route_table" "kong_vpc_nat_gw_route_table" {
  vpc_id = aws_vpc.kong_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.kong_vpc_nat_gw.id
  }

  tags = {
    Name = "kong_vpc_nat_gw_route_table"
  }
}

# Terraform  private routes
resource "aws_route_table_association" "private_subnet_1_nat_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.kong_vpc_nat_gw_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_nat_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.kong_vpc_nat_gw_route_table.id
}
