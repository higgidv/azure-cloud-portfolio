# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-containerplatform-${var.environment}-${random_integer.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.security.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days[var.environment]
  
  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}