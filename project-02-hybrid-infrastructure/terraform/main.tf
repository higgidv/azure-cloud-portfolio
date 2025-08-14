terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use existing resource groups as data sources
data "azurerm_resource_group" "onprem" {
  name = "rg-hybrid-demo-onprem-eastus"
}

data "azurerm_resource_group" "prod" {
  name = "rg-hybrid-demo-cloud-westus2"
}
