# Public IPs for VPN Gateways
resource "azurerm_public_ip" "onprem_vpn" {
  name                = "pip-vpngw-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = data.azurerm_resource_group.onprem.tags
}

resource "azurerm_public_ip" "prod_vpn" {
  name                = "pip-vpngw-prod"
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = data.azurerm_resource_group.prod.tags
}

# VPN Gateways (These take 30-45 minutes to deploy)
resource "azurerm_virtual_network_gateway" "onprem" {
  name                = "vpngw-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  
  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"
  
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_gateway.id
  }
  
  tags = data.azurerm_resource_group.onprem.tags
}

resource "azurerm_virtual_network_gateway" "prod" {
  name                = "vpngw-prod"
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name
  
  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"
  
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.prod_vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.prod_gateway.id
  }
  
  tags = data.azurerm_resource_group.prod.tags
}

# Local Network Gateways
resource "azurerm_local_network_gateway" "onprem_to_prod" {
  name                = "lng-to-prod"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  gateway_address     = azurerm_public_ip.prod_vpn.ip_address
  address_space       = ["172.16.0.0/16"]
  
  tags = data.azurerm_resource_group.onprem.tags
}

resource "azurerm_local_network_gateway" "prod_to_onprem" {
  name                = "lng-to-onprem"
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name
  gateway_address     = azurerm_public_ip.onprem_vpn.ip_address
  address_space       = ["10.0.0.0/16"]
  
  tags = data.azurerm_resource_group.prod.tags
}

# VPN Connections
resource "azurerm_virtual_network_gateway_connection" "onprem_to_prod" {
  name                = "conn-onprem-to-prod"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_to_prod.id
  
  shared_key = var.vpn_shared_key
  
  tags = data.azurerm_resource_group.onprem.tags
}

resource "azurerm_virtual_network_gateway_connection" "prod_to_onprem" {
  name                = "conn-prod-to-onprem"
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name
  
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.prod.id
  local_network_gateway_id   = azurerm_local_network_gateway.prod_to_onprem.id
  
  shared_key = var.vpn_shared_key
  
  tags = data.azurerm_resource_group.prod.tags
}
