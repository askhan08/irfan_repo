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
  tags = var.apptag
}


resource "aws_subnet" "db-subnet" {
  count = length(var.db-subnets)
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = element(var.db-subnets, count.index)
  availability_zone = element(var.azs, count.index)
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

resource "aws_eip" "ngw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "web-nw" {
  subnet_id = element(aws_subnet.web-subnet.*.id, 0)
  allocation_id = aws_eip.ngw-eip.id
}

resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web-nw.id
  }
}

resource "aws_route_table_association" "app-rt-ass" {
  count = length(var.app-subnets)
  route_table_id = aws_route_table.app-rt.id
  subnet_id = element(aws_subnet.app-subnet.*.id, count.index)
}

resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web-nw.id
  }
}

resource "aws_route_table_association" "db-rt-ass" {
  count = length(var.db-subnets)
  route_table_id = aws_route_table.db-rt.id
  subnet_id = element(aws_subnet.db-subnet.*.id, count.index)
}

module "sg-label-web" {
  source = "../label"
  namespace  = var.project
  stage      = var.pillar
  name       = "WEB-SG"
}

resource "aws_security_group" "web-sg" {
  name = module.sg-label-web.id
  vpc_id = aws_vpc.main-vpc.id
  description = "tfc btw public and web"
  dynamic "ingress" {
    for_each = var.web_ports
    content {
      from_port = ingress.value
      protocol  = "tcp"
      to_port   = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "sg-label-app" {
  source = "../label"
  namespace  = upper(var.project)
  stage      = upper(var.pillar)
  name       = "APP-SG"
}

resource "aws_security_group" "app-sg" {
  name = module.sg-label-app.id
  vpc_id = aws_vpc.main-vpc.id
  description = "tfc btw app server and web server"
  dynamic "ingress" {
    for_each = var.app_ports
    content {
      from_port = ingress.value
      protocol  = "tcp"
      to_port   = ingress.value
      security_groups = [aws_security_group.web-sg.id]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#module "sg-label-eks" {
#  source = "../label"
#  namespace  = upper(var.project)
#  stage      = upper(var.pillar)
#  name       = "EKS-SG"
#}
#
#resource "aws_security_group" "eks-sg" {
#  name = module.sg-label-eks.id
#  vpc_id = aws_vpc.main-vpc.id
#  description = "sg for eks control plane"
#  ingress {
#    from_port = 0
#    to_port   = 0
#    protocol  = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  egress {
#    from_port = 0
#    to_port   = 0
#    protocol  = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

module "sg-label-db" {
  source = "../label"
  namespace  = upper(var.project)
  stage      = upper(var.pillar)
  name       = "DB-SG"
}
resource "aws_security_group" "db-sg" {
  name = module.sg-label-db.id
  vpc_id = aws_vpc.main-vpc.id
  description = "tfc btw DB server and APP server"
  dynamic "ingress" {
    for_each = var.db_ports
    content {
      from_port = ingress.value
      protocol  = "tcp"
      to_port   = ingress.value
      security_groups = [aws_security_group.app-sg.id]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}