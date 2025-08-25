terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85" # Use a recent stable version
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate random suffix for unique naming
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Core infrastructure resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}

# Networking
resource "azurerm_resource_group" "networking" {
  name     = "${var.resource_group_name}-networking-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}

# Security
resource "azurerm_resource_group" "security" {
  name     = "${var.resource_group_name}-security-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "container-platform"
    ManagedBy   = "terraform"
  }
}