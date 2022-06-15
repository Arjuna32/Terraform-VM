terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id   = "<subscription id>"
  tenant_id         = "<tenant id>"
  client_id         = "<client id>"
  client_secret     = "<client secret>"
}
