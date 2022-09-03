variable "vpc-cidr" {
  type = string
  default = "172.16.0.0/16"
}

variable "vpctag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-DEV-VPC"
  }
}

variable "web-subnets" {
  type = list(string)
  default = ["172.16.0.0/20","172.16.16.0/20","172.16.32.0/20"]
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
    Name = "MYORG-DEV-subnets-web"
  }
}

variable "app-subnets" {
  type = list(string)
  default = ["172.16.48.0/20","172.16.64.0/20","172.16.80.0/20"]
}

variable "apptag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-DEV-subnets-app"
  }
}

variable "db-subnets" {
  type = list(string)
  default = ["172.16.96.0/20","172.16.112.0/20","172.16.128.0/20"]
}

variable "dbtag" {
  type = object({
    Name = string
  })
  default = {
    Name = "MYORG-DEV-subnets-db"
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

variable "web-sg" {
  default = "MYORG-DEV-WEB-SG"
}

variable "app-sg" {
  default = "MYORG-DEV-APP-SG"
}

variable "web_ports" {
  type = list(number)
  default = [22 , 80]
}

variable "app_ports" {
  type = list(number)
  default = [22 , 5000]
}