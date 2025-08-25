# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-containerplatform-${var.environment}-${random_integer.suffix.result}"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "subnet-aks-${var.environment}"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_address_prefix]
}

# Network Security Group for AKS subnet
resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-${var.environment}-${random_integer.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name

  # Start with minimal rules - AKS will manage most security
  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}

# Associate NSG with AKS subnet
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}