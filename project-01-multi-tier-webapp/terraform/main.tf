# Generate random suffix for unique naming
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}-${random_integer.suffix.result}"
  location = var.location
  tags     = var.tags
}

# Storage Account for diagnostics
resource "azurerm_storage_account" "diagnostics" {
  name                     = "diag${var.project_name}${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  random_suffix       = tostring(random_integer.suffix.result)
  tags                = var.tags
}
