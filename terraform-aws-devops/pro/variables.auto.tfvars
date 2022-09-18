project="MYORG"
pillar="PRO"
vpc-cidr="172.18.0.0/16"
vpctag= {
  Name = "MYORG-PRO-VPC"
}
keyname = "login-key-pro"
web-subnets=["172.18.0.0/20","172.18.16.0/20","172.18.32.0/20"]
app-subnets=["172.18.48.0/20","172.18.64.0/20","172.18.80.0/20"]
db-subnets=["172.18.96.0/20","172.18.112.0/20","172.18.128.0/20"]
azs=["us-east-1a","us-east-1b","us-east-1c"]

