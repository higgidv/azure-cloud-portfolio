# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# SQL Server
resource "azurerm_mssql_server" "prod" {
  name                         = "sql-hybrid-demo-${random_string.suffix.result}"
  location                     = data.azurerm_resource_group.prod.location
  resource_group_name          = data.azurerm_resource_group.prod.name
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  
  tags = data.azurerm_resource_group.prod.tags
}

# SQL Database (Basic tier)
resource "azurerm_mssql_database" "prod" {
  name           = "HybridDemoDB"
  server_id      = azurerm_mssql_server.prod.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
  
  tags = data.azurerm_resource_group.prod.tags
}

# SQL Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.prod.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# SQL Firewall rule to allow on-premises network
resource "azurerm_mssql_firewall_rule" "onprem_network" {
  name             = "AllowOnPremisesNetwork"
  server_id        = azurerm_mssql_server.prod.id
  start_ip_address = "10.0.0.0"
  end_ip_address   = "10.0.255.255"
}

# Data source for current Azure client config
data "azurerm_client_config" "current" {}