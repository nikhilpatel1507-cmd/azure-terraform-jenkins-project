module "networking" {
  source = "../../modules/networking"

  project            = var.project
  environment        = var.environment
  location           = var.location
  vnet_address_space = var.vnet_address_space
  app_subnet_prefix  = var.app_subnet_prefix
  db_subnet_prefix   = var.db_subnet_prefix
  admin_source_cidr  = var.admin_source_cidr
  tags               = var.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  tags                = var.tags
}

module "database" {
  source = "../../modules/database"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  vnet_id             = module.networking.vnet_id
  db_subnet_id        = module.networking.db_subnet_id
  sku_name            = var.db_sku_name
  admin_password      = module.keyvault.db_admin_password
  tags                = var.tags
}

module "compute" {
  source = "../../modules/compute"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  app_subnet_id       = module.networking.app_subnet_id
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  tags                = var.tags
}
