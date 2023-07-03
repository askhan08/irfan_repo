data "aws_vpc" "vpcid" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.pillar}-VPC"]
  }
}

data "aws_security_group" "web1-sg" {
  filter {
    name   = "group-name"
    values = ["${lower(var.project)}-${lower(var.pillar)}-web-sg"]
  }
}

data "aws_security_group" "app-sg" {
  filter {
    name   = "group-name"
    values = ["${lower(var.project)}-${lower(var.pillar)}-app-sg"]
  }
}

data "aws_subnets" "web-subnet-id" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcid.id]
  }
  tags = {
    Name = "${var.project}-subnets-web"
    Tier = "web"
  }
}

data "aws_subnets" "app-subnet-id" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpcid.id]
  }
  tags = {
    Name = "${var.project}-subnets-app"
    Tier = "app"
  }
}

resource "tls_private_key" "instance-pvt-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "instance-key" {
  public_key = tls_private_key.instance-pvt-key.public_key_openssh
  key_name = var.keyname
}
data "aws_ssm_parameter" "" {
  name = ""
}

resource "aws_instance" "generic-web" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = ["${data.aws_security_group.web-sg.id}"]
  subnet_id = element(data.aws_subnets.web-subnet-id.ids, 0)
  key_name = aws_key_pair.instance-key.key_name
  depends_on = [data.aws_security_group.web-sg,data.aws_subnets.web-subnet-id]
  user_data = "{ data }"
  tags = {
    Name = "web-server1"
  }
}

resource "aws_instance" "generic-app" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = ["${data.aws_security_group.app-sg.id}"]
  subnet_id = element(data.aws_subnets.app-subnet-id.ids, 0)
  key_name = aws_key_pair.instance-key.key_name
  depends_on = [data.aws_security_group.app-sg, data.aws_subnets.app-subnet-id]
  tags = {
    Name = "app-server1"
  }
}