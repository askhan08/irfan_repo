variable "project" {}

variable "pillar" {}

variable "vpc-cidr" {
  type = string
}

variable "vpctag" {
  type = object({
    Name = string
  })
}

variable "web-subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "webtag" {
  type = object({
    Name = string
    Tier = string
  })
  default = {
    Name = "MYORG-subnets-web"
    Tier = "web"
  }
}

variable "app-subnets" {
  type = list(string)
}

variable "apptag" {
  type = object({
    Name = string
    Tier = string
  })
  default = {
    Name = "MYORG-subnets-app"
    Tier = "app"
  }
}

variable "db-subnets" {
  type = list(string)
}

variable "dbtag" {
  type = object({
    Name = string
    Tier = string
  })
  default = {
    Name = "MYORG-subnets-db"
    Tier = "db"
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


variable "web_ports" {
  type = list(number)
  default = [22 , 80]
}

variable "app_ports" {
  type = list(number)
  default = [22 , 8080]
}

variable "db_ports" {
  type = list(number)
  default = [22 , 27017]
}

variable "keyname" {
  type = string
}