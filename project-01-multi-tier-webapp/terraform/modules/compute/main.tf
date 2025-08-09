# App Service Plan (Basic tier for free credits)
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.project_name}-${var.environment}-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  
  tags = var.tags
}

# App Service
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.project_name}-${var.environment}-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false  # Basic tier doesn't support always_on
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "ENVIRONMENT"                  = var.environment
    "PROJECT_NAME"                 = var.project_name
  }

  tags = var.tags
}

# VNet Integration for App Service
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = var.app_service_subnet_id
}
