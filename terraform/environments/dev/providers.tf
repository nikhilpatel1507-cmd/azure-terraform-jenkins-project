terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }

  # Local backend for now (works against floci-az).
  # Switch to the azurerm backend once pointed at a real Azure subscription -
  # see backend.tf.example in the repo root for the remote-state version.
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  use_cli                         = false

  # --- Local (floci-az) values - replace with real values for actual Azure ---
  environment   = var.azure_environment
  metadata_host = var.azure_metadata_host

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}
