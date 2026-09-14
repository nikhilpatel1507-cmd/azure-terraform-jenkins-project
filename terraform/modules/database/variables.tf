variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "db_subnet_id" {
  type = string
}

variable "sku_name" {
  description = "Flexible server SKU, e.g. B_Standard_B1ms for dev, GP_Standard_D2s_v3 for prod"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "admin_username" {
  type    = string
  default = "psqladmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
