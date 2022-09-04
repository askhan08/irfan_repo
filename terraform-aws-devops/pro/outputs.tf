output "vpcid" {
  value = module.network.vpcid
}

output "pri_key" {
  value = module.compute.pri_key
  sensitive = true
}