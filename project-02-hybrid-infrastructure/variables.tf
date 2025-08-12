variable "vpn_shared_key" {
  description = "Shared key for VPN connection"
  type        = string
  sensitive   = true
  default     = "Enterprise-Demo-Key-2025!"
}

variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Administrator password for VMs"
  type        = string
  sensitive   = true
  default     = "ComplexP@ssw0rd123!"
}
