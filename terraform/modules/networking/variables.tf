variable "project" {
  description = "Short project name used in resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR block for the VNet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR block for the app-tier subnet"
  type        = string
}

variable "db_subnet_prefix" {
  description = "CIDR block for the db-tier subnet"
  type        = string
}

variable "admin_source_cidr" {
  description = "CIDR allowed to SSH into the app tier"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
