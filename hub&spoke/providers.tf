terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.58"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "103d8a1a-c11c-4fe3-a5fb-7f31ce1ec9ec"
  tenant_id       = "dde3bd8b-eaff-4a8e-91e3-0f82f56c27b6"
  client_id       = "76ff35a5-e2c1-42b5-8d3f-1ae9f446c32f"
  client_secret   = "G_J8Q~SLwdU_lnYxluHcR1p_mYfdU6C8ZmGuKdjL"
}