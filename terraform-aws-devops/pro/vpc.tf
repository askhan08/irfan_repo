module "network" {
  source = "../module/vpc"
  vpc-cidr = var.vpc-cidr
  vpctag = var.vpctag
  web-subnets = var.web-subnets
  azs = var.azs
  webtag = var.webtag
  app-subnets = var.app-subnets
  apptag = var.apptag
  db-subnets = var.db-subnets
  dbtag = var.dbtag
  globaltag = var.globaltag
}