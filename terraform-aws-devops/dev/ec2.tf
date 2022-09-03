module "compute" {
  source = "../module/ec2"
  web-sg = var.web-sg
  app-sg = var.app-sg
  vpctag = var.vpctag
  webtag = var.webtag
  apptag = var.apptag
  depends_on = [module.network]
}