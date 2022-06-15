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
  subscription_id   = "e11450e3-e07c-413a-8d16-f51e5e82a784"
  tenant_id         = "e354459a-7e70-4d52-be86-390b6c7b74f1"
  client_id         = "7f8d4fbd-4219-4992-b046-21987e974ff8"
  client_secret     = "o388Q~MjUf4cAzj81j6ZDG1GClgO2~qq6SozEc2x"
}
