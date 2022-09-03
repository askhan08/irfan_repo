data "aws_vpc" "vpcid" {
  id = "MYORG-DEV-VPC"
}

data "aws_security_group" "web-sg" {
  id = var.web-sg
}

data "aws_security_group" "app-sg" {
  id = var.app-sg
}

data "aws_subnets" "web-subnet-id" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcid.id]
  }
  tags = {
    Name = "MYORG-DEV-subnets-web"
  }
}

data "aws_subnets" "app-subnet-id" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcid.id]
  }
  tags = {
    Name = "MYORG-DEV-subnets-app"
  }
}

resource "tls_private_key" "instance-pvt-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "instance-key" {
  public_key = tls_private_key.instance-pvt-key.public_key_openssh
  key_name = "login-key"
}


resource "aws_instance" "generic-web" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = [data.aws_security_group.web-sg.id]
  subnet_id = element(data.aws_subnets.web-subnet-id.ids, 0)
  key_name = aws_key_pair.instance-key.key_name
  depends_on = [data.aws_security_group.web-sg]
  tags = {
    Name = "web-server1"
  }
}

resource "aws_instance" "generic-app" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = [data.aws_security_group.web-sg.id]
  subnet_id = element(data.aws_subnets.app-subnet-id.ids, 0)
  key_name = aws_key_pair.instance-key.key_name
  depends_on = [data.aws_security_group.app-sg]
  tags = {
    Name = "app-server1"
  }
}