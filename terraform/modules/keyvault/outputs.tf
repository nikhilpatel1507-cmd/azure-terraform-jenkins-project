output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "db_admin_password_secret_id" {
  value = azurerm_key_vault_secret.db_admin_password.id
}

output "db_admin_password" {
  value     = random_password.db_password.result
  sensitive = true
}
