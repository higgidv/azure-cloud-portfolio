# Public IPs for VPN Gateways
resource "azurerm_public_ip" "onprem_vpn" {
  name                = "pip-vpngw-onprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = azurerm_resource_group.onprem.tags
}

resource "azurerm_public_ip" "prod_vpn" {
  name                = "pip-vpngw-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = azurerm_resource_group.prod.tags
}

# VPN Gateways (These take 30-45 minutes to deploy)
resource "azurerm_virtual_network_gateway" "onprem" {
  name                = "vpngw-onprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_gateway.id
  }

  tags = azurerm_resource_group.onprem.tags
}

resource "azurerm_virtual_network_gateway" "prod" {
  name                = "vpngw-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.prod_vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.prod_gateway.id
  }

  tags = azurerm_resource_group.prod.tags
}
