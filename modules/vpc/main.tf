resource "aws_vpc" "public_vpc" {
  cidr_block           = var.public_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_vpc" "private_vpc" {
  cidr_block           = var.private_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.public_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.public_vpc.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.private_vpc.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.private_vpc.id
  cidr_block = "10.20.13.0/24"
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.public_vpc.id
  peer_vpc_id = aws_vpc.private_vpc.id
  auto_accept = true

  tags = {
    Name = "Public-Private-Peering"
  }
}

# Route from public VPC to private VPC
resource "aws_route" "public_to_private" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = var.private_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}

# Route from private VPC to public VPC
resource "aws_route" "private_to_public" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
}

resource "aws_subnet" "database_subnet_1" {
  vpc_id     = aws_vpc.private_vpc.id
  cidr_block = "10.20.20.0/24"
}

resource "aws_subnet" "database_subnet_2" {
  vpc_id     = aws_vpc.private_vpc.id
  cidr_block = "10.20.21.0/24"
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.private_vpc.id
}

resource "aws_route_table_association" "database_subnet_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_route_table_association" "database_subnet_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.private_vpc.id
  service_name = "com.amazonaws.ap-southeast-2.dynamodb"
  route_table_ids = [aws_route_table.private_route_table.id]
}