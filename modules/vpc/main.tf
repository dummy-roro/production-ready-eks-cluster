resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "public" {
  count             = var.pub_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub_cidr_block[count.index]
  availability_zone = var.pub_availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.pub_sub_name}-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = var.pri_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri_cidr_block[count.index]
  availability_zone = var.pri_availability_zone[count.index]
  tags = {
    Name = "${var.pri_sub_name}-${count.index}"
  }
}

resource "aws_eip" "ngw" {
  tags = {
    Name = var.eip_name
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = var.ngw_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.public_rt_name
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.pub_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.private_rt_name
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.pri_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
