variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Networking inputs from networking module
variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  type        = string
}

variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan"
  type        = string
  default     = "B1"  # Basic tier instead of Premium
}
