# terraform-multi-ec2-app/main.tf

resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.app_name}-VPC"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name        = "${var.app_name}-PublicSubnet"
    Environment = "Dev"
  }
}

resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name        = "${var.app_name}-IGW"
    Environment = "Dev"
  }
}

resource "aws_route_table" "app-route-table" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name        = "${var.app_name}-RouteTable"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.app-route-table.id
}
