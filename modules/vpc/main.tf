resource "aws_vpc" "this" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw-name
  }
}

resource "aws_subnet" "public" {
  count                    = var.pub-subnet-count
  vpc_id                   = aws_vpc.this.id
  cidr_block               = var.pub-cidr-block[count.index]
  availability_zone        = var.pub-availability-zone[count.index]
  map_public_ip_on_launch  = true

  tags = {
    Name = "${var.pub-sub-name}-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = var.pri-subnet-count
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.pri-cidr-block[count.index]
  availability_zone = var.pri-availability-zone[count.index]

  tags = {
    Name = "${var.pri-sub-name}-${count.index}"
  }
}

resource "aws_eip" "ngw" {
  tags = {
    Name = var.eip-name
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = var.ngw-name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = var.private-rt-name
  }
}

resource "aws_route_table_association" "public" {
  count          = var.pub-subnet-count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.pri-subnet-count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
