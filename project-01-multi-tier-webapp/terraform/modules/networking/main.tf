# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}-${var.random_suffix}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = var.tags
}

# Application Gateway Subnet
resource "azurerm_subnet" "appgw" {
  name                 = "snet-appgw-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# App Service Subnet (for VNet integration)
resource "azurerm_subnet" "app_service" {
  name                 = "snet-app-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Database Subnet (for private endpoints)
resource "azurerm_subnet" "database" {
  name                 = "snet-db-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Network Security Group for App Service Subnet
resource "azurerm_network_security_group" "app_service" {
  name                = "nsg-app-${var.environment}-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTP/HTTPS inbound
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Network Security Group for Database Subnet
resource "azurerm_network_security_group" "database" {
  name                = "nsg-db-${var.environment}-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow SQL traffic from App Service subnet
  security_rule {
    name                       = "AllowSQLFromAppService"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with App Service Subnet
resource "azurerm_subnet_network_security_group_association" "app_service" {
  subnet_id                 = azurerm_subnet.app_service.id
  network_security_group_id = azurerm_network_security_group.app_service.id
}

# Associate NSG with Database Subnet
resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}