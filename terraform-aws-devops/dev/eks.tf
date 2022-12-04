module "ekscluster" {
  source = "../module/eks"
  pillar = var.pillar
  project = var.project
  depends_on = [module.network]
}