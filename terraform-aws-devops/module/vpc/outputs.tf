output "vpcid" {
  value = aws_vpc.main-vpc.id
}

output "web_sg_name" {
  value = aws_security_group.web-sg.name
}

output "app_sg_name" {
  value = aws_security_group.app-sg.name
}

output "web_subnets" {
  value = aws_subnet.web-subnet.*.id
}

output "app_subnets" {
  value = aws_subnet.app-subnet.*.id
}

#output "eks_sg" {
#  value = aws_security_group.eks-sg.id
#}