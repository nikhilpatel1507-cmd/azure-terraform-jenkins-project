output "app_public_ip" {
  value = module.compute.public_ip_address
}

output "db_server_fqdn" {
  value = module.database.server_fqdn
}

output "key_vault_id" {
  value = module.keyvault.key_vault_id
}
