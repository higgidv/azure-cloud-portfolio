variable "vpn_shared_key" {
  description = "Shared key for VPN connection"
  type        = string
  sensitive   = true
  # Default removed for security reasons - set via terraform.tfvars or environment variable
}

variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
  # Default removed for security reasons - set via terraform.tfvars or environment variable
}

variable "admin_password" {
  description = "Administrator password for VMs"
  type        = string
  sensitive   = true
  # Default removed for security reasons - set via terraform.tfvars or environment variable
}
