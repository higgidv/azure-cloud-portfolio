variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, test, prod."
  }
}

variable "vm_sizes" {
  description = "VM sizes by environment"
  type        = map(string)
  default = {
    dev     = "Standard_B2s"
    staging = "Standard_B2s"
    test    = "Standard_B2s"
    prod    = "Standard_D2s_v3"
  }
}

variable "node_scaling" {
  type = map(object({
    initial = number
    min     = number
    max     = number
  }))
  default = {
    dev = {
      initial = 1
      min     = 1
      max     = 2
    }
    staging = {
      initial = 1
      min     = 1
      max     = 2
    }
    test = {
      initial = 1
      min     = 1
      max     = 2
    }
    prod = {
      initial = 2
      min     = 2
      max     = 10
    }
  }
}

variable "hpa_scaling" {
  description = "HPA pod scaling limits by environment"
  type = map(object({
    min_pods           = number
    max_pods           = number
    target_cpu_percent = number
  }))
  default = {
    dev = {
      min_pods           = 1  # Dev: keep costs low
      max_pods           = 5  # Don't need huge scale in dev
      target_cpu_percent = 80 # Allow higher CPU before scaling
    }
    prod = {
      min_pods           = 2  # Prod: redundancy always
      max_pods           = 5  # Handle real traffic spikes
      target_cpu_percent = 70 # scale sooner for performance
    }
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westus3"
}

variable "resource_group_name" {
  description = "Base name for resource groups"
  type        = string
  default     = "rg-container"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefix" {
  description = "Address prefix for AKS subnet"
  type        = string
  default     = "10.0.0.0/22"
}