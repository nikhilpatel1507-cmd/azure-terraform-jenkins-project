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

variable "app_subnet_id" {
  type = string
}

variable "vm_size" {
  description = "e.g. Standard_B1s for dev, Standard_D2s_v3 for prod"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "Public SSH key content for admin login"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
