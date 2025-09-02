# Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = "kv-containerplatform-${var.environment}-${random_integer.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.security.name
  tenant_id          = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}

data "azurerm_client_config" "current" {}