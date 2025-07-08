# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-${var.vpc_name}"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = var.pub_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.pub_cidr_block, count.index)
  availability_zone       = element(var.pub_availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.env}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = var.pri_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.pri_cidr_block, count.index)
  availability_zone = element(var.pri_availability_zone, count.index)
  tags = {
    Name                              = "${var.env}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.pub_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways for Private Subnets
resource "aws_eip" "nat" {
  count  = var.pri_subnet_count
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.pri_subnet_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.main]
}

# Private Route Tables
resource "aws_route_table" "private" {
  count  = var.pri_subnet_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = {
    Name = "${var.env}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.pri_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
