resource "aws_iam_role" "eks_role" {
  name = "eks_control_plane_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "eksrole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "eks-controlplane-role"
  }
}

data "aws_iam_policy" "cluster_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cp-attach" {
  policy_arn = data.aws_iam_policy.cluster_policy.arn
  role       = aws_iam_role.eks_role.name
}

#data "aws_security_group" "eks-sg" {
#  filter {
#    name   = "group-name"
#    values = ["${upper(var.project)}-${upper(var.pillar)}-EKS-SG"]
#  }
#}

resource "aws_iam_role" "node_role" {
  name = "eks_worker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ec2role"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.value
  role       = aws_iam_role.node_role.name
}