variable "vpc-cidr" {
  type = string
  default = "172.17.0.0/16"
}

variable "vpctag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-ACC-VPC"
  }
}

variable "web-subnets" {
  type = list(string)
  default = ["172.17.0.0/20","172.17.16.0/20","172.17.32.0/20"]
}

variable "azs" {
  type = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "webtag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-ACC-subnets-web"
  }
}

variable "app-subnets" {
  type = list(string)
  default = ["172.17.48.0/20","172.17.64.0/20","172.17.80.0/20"]
}

variable "apptag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-ACC-subnets-app"
  }
}

variable "db-subnets" {
  type = list(string)
  default = ["172.17.96.0/20","172.17.112.0/20","172.17.128.0/20"]
}

variable "dbtag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-ACC-subnets-db"
  }
}

variable "globaltag" {
  type = object({
    Name = string
  })
  default = {
    Name = "global"
  }
}