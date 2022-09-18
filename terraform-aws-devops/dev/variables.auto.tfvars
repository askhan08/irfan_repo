project="MYORG"
pillar="DEV"
vpc-cidr="172.16.0.0/16"
vpctag={
  Name = "MYORG-DEV-VPC"
}
keyname = "login-key-dev1"
web-subnets=["172.16.0.0/20","172.16.16.0/20","172.16.32.0/20"]
app-subnets=["172.16.48.0/20","172.16.64.0/20","172.16.80.0/20"]
db-subnets=["172.16.96.0/20","172.16.112.0/20","172.16.128.0/20"]
azs=["us-east-1a","us-east-1b","us-east-1c"]

