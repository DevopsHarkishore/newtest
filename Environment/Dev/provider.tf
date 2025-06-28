terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "180d2ab6-0ded-4071-b4c9-3ebefd722b58"
}