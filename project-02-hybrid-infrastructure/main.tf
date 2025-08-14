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

# Resource Groups
resource "azurerm_resource_group" "onprem" {
  name     = "rg-hybrid-demo-onprem-eastus"
  location = "East US"

  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
    CostCenter  = "IT-Infrastructure"
  }
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-hybrid-demo-cloud-westus2"
  location = "West US 2"

  tags = {
    Environment = "Production"
    Project     = "HybridCloudArchitecture"
    CostCenter  = "IT-Infrastructure"
  }
}