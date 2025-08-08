variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US 2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "webapp"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "Multi-Tier-WebApp"
    Environment = "Development"
    Owner       = "DaSean"
    CostCenter  = "Learning"
  }
}
