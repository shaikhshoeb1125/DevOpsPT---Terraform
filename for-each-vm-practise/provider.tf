terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.47.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "16112944-fd51-430f-bfb9-9d32892257ad"
  tenant_id       = "f071f990-4dfc-42b8-a903-d40289469da7"
  client_id       = "e5308052-ad75-4a01-bd7f-46a36fefe1c4"
  client_secret   = "4dZ8Q~~5wGtYTOJehVzRpQo-gI~liQHMva4tEbKk"
}


