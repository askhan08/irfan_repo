module "sg-label-eks" {
  source = "../label"
  namespace  = upper(var.project)
  stage      = upper(var.pillar)
  name       = "eks-cluster"
}

data "aws_vpc" "vpcid" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.pillar}-VPC"]
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

resource "aws_eks_cluster" "eks-cluster" {
  name     = module.sg-label-eks.id
  role_arn = aws_iam_role.eks_role.arn
  version = "1.23"
  vpc_config {
    security_group_ids = []
    subnet_ids = data.aws_subnets.app-subnet-id.ids
    endpoint_private_access = true
    endpoint_public_access = true
  }
  depends_on = [aws_iam_role.eks_role, data.aws_subnets.app-subnet-id]
}

resource "aws_eks_node_group" "eks-cluster-nodes" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "group-1"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.app-subnet-id.ids
  instance_types = ["t2.small"]
  version = "1.23"
  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [aws_iam_role.node_role]
}