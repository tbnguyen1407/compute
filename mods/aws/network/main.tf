terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

## network
resource "aws_vpc" "net0" {
  ## required
  cidr_block = var.network_cidr_block

  ## optional
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.network_name
  }
}

resource "aws_subnet" "subnet0" {
  ## required  
  vpc_id     = aws_vpc.net0.id
  cidr_block = var.subnet_cidr_block

  ## optional
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

## internet gateway
resource "aws_internet_gateway" "igw0" {
  ## required
  vpc_id = aws_vpc.net0.id

  ## optional
  tags = {
    Name = "igw0"
  }
}

resource "aws_route_table" "rt0" {
  ## required
  vpc_id = aws_vpc.net0.id
}

resource "aws_route_table_association" "rta0" {
  ## required
  route_table_id = aws_route_table.rt0.id
  subnet_id      = aws_subnet.subnet0.id
}

resource "aws_route" "route0" {
  ## required
  route_table_id         = aws_route_table.rt0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw0.id
}

