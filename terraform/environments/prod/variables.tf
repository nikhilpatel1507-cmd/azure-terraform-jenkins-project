variable "project" {
  type    = string
  default = "devopsdemo"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vnet_address_space" {
  type    = string
  default = "10.20.0.0/16"
}

variable "app_subnet_prefix" {
  type    = string
  default = "10.20.1.0/24"
}

variable "db_subnet_prefix" {
  type    = string
  default = "10.20.2.0/24"
}

variable "admin_source_cidr" {
  type    = string
  default = "*" # tighten to your IP/CIDR for real Azure use
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "db_sku_name" {
  type    = string
  default = "GP_Standard_D2s_v3"
}

variable "ssh_public_key" {
  description = "Contents of your public SSH key, e.g. cat ~/.ssh/id_rsa.pub"
  type        = string
}

# --- Provider connection settings (floci-az defaults shown) ---
variable "azure_environment" {
  type    = string
  default = "stack"
}

variable "azure_metadata_host" {
  type    = string
  default = "localhost:4577"
}

variable "azure_subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000001"
}

variable "azure_tenant_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000002"
}

variable "azure_client_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000003"
}

variable "azure_client_secret" {
  type      = string
  default   = "fake-secret"
  sensitive = true
}

variable "tags" {
  type = map(string)
  default = {
    project     = "devopsdemo"
    environment = "dev"
    managed_by  = "terraform"
  }
}
