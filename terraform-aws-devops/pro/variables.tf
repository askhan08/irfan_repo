variable "vpc-cidr" {
  type = string
  default = "172.18.0.0/16"
}

variable "vpctag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-PRO-VPC"
  }
}

variable "web-subnets" {
  type = list(string)
  default = ["172.18.0.0/20","172.18.16.0/20","172.18.32.0/20"]
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
    Name = "MYORG-PRO-subnets-web"
  }
}

variable "app-subnets" {
  type = list(string)
  default = ["172.18.48.0/20","172.18.64.0/20","172.18.80.0/20"]
}

variable "apptag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-PRO-subnets-app"
  }
}

variable "db-subnets" {
  type = list(string)
  default = ["172.18.96.0/20","172.18.112.0/20","172.18.128.0/20"]
}

variable "dbtag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-PRO-subnets-db"
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