output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

output "website_url" {
  description = "URL of the static website"
  value       = azurerm_storage_account.website.primary_web_endpoint
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnets" {
  description = "Subnet information"
  value = {
    web  = azurerm_subnet.web.address_prefixes[0]
    app  = azurerm_subnet.app.address_prefixes[0]
    data = azurerm_subnet.data.address_prefixes[0]
    mgmt = azurerm_subnet.mgmt.address_prefixes[0]
  }
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "random_suffix" {
  description = "Random suffix used for naming"
  value       = random_integer.suffix.result
}
