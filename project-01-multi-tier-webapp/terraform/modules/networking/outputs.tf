output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.appgw.id
}

output "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  value       = azurerm_subnet.app_service.id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

output "app_service_nsg_id" {
  description = "ID of the App Service network security group"
  value       = azurerm_network_security_group.app_service.id
}

output "database_nsg_id" {
  description = "ID of the database network security group"
  value       = azurerm_network_security_group.database.id
}
