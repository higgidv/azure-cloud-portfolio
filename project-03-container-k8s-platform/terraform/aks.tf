resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-containerplatform-${var.environment}-${random_integer.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-${var.environment}-${random_integer.suffix.result}"

  default_node_pool {
    name                = "default"
    node_count          = var.node_scaling[var.environment].initial
    vm_size             = var.vm_sizes[var.environment]
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = true
    min_count           = var.node_scaling[var.environment].min
    max_count           = var.node_scaling[var.environment].max
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "10.0.100.10"
    service_cidr       = "10.0.100.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}