project="MYORG"
pillar="PRO"
vpc-cidr="172.17.0.0/16"
vpctag= {
  Name = "MYORG-PRO-VPC"
}
web-subnets=["172.17.0.0/20","172.17.16.0/20","172.17.32.0/20"]
app-subnets=["172.17.48.0/20","172.17.64.0/20","172.17.80.0/20"]
db-subnets=["172.17.96.0/20","172.17.112.0/20","172.17.128.0/20"]
azs=["us-east-1a","us-east-1b","us-east-1c"]

