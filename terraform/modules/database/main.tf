resource "azurerm_private_dns_zone" "db_dns" {
  name                = "${var.project}${var.environment}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "db_dns_link" {
  name                = "${var.project}-${var.environment}-db-dns-link"
  private_dns_zone_id = azurerm_private_dns_zone.db_dns.id
  virtual_network_id  = var.vnet_id
}
resource "azurerm_postgresql_flexible_server" "db" {
  name                = "${var.project}-${var.environment}-psql"
  resource_group_name = var.resource_group_name
  location            = var.location

  version    = "15"
  sku_name   = var.sku_name
  storage_mb = var.storage_mb

  delegated_subnet_id = var.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.db_dns.id

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  backup_retention_days = 7
  zone                  = "1"
  tags                  = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.db_dns_link]
}

resource "azurerm_postgresql_flexible_server_database" "app_db" {
  name      = "${var.project}_${var.environment}_appdb"
  server_id = azurerm_postgresql_flexible_server.db.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
