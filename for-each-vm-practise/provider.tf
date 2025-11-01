terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.47.0"
    }
  }
}

# Add your service principle credentials accordingly
provider "azurerm" {
  features {}
  subscription_id = "16112944-fd51-430f-bfb9-9d32892257ad"
  tenant_id       = "f071f990-4dfc-42b8-a903-d40289469da7"

}


