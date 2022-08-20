resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = var.vpctag
}

resource "aws_subnet" "web-subnet" {
  count = length(var.web-subnets)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = element(var.web-subnets, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = var.webtag
}


resource "aws_subnet" "app-subnet" {
  count = length(var.app-subnets)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = element(var.app-subnets, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = var.apptag
}


resource "aws_subnet" "db-subnet" {
  count = length(var.db-subnets)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = element(var.db-subnets, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = var.dbtag
}

resource "aws_internet_gateway" "mngt-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = var.globaltag
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mngt-igw.id
  }
}

resource "aws_route_table_association" "web-rt-ass" {
  count = length(var.web-subnets)
  route_table_id = aws_route_table.web-rt.id
  subnet_id = element(aws_subnet.web-subnet.*.id, count.index)
}
