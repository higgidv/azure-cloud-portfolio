# Virtual Networks
resource "azurerm_virtual_network" "onprem" {
  name                = "vnet-onprem-eastus"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  
  tags = data.azurerm_resource_group.onprem.tags
}

resource "azurerm_virtual_network" "prod" {
  name                = "vnet-prod-westus2"
  address_space       = ["172.16.0.0/16"]
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name
  
  tags = data.azurerm_resource_group.prod.tags
}

# On-premises subnets
resource "azurerm_subnet" "onprem_internal" {
  name                 = "subnet-internal"
  resource_group_name  = data.azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "onprem_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.0.255.0/27"]
}

# Production cloud subnets
resource "azurerm_subnet" "prod_web" {
  name                 = "subnet-web"
  resource_group_name  = data.azurerm_resource_group.prod.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "prod_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.prod.name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = ["172.16.255.0/27"]
}
