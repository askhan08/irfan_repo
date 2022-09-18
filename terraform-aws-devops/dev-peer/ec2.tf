module "compute" {
  source = "../module/ec2"
  vpctag = var.vpctag
  webtag = var.webtag
  apptag = var.apptag
  pillar = var.pillar
  project = var.project
  depends_on = [module.network]
  keyname = var.keyname
}