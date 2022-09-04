output "pri_key" {
  value = tls_private_key.instance-pvt-key.private_key_pem
  sensitive = true
}