output "domain_controller" {
  description = "Domain Controller connection information"
  value = {
    private_ip = azurerm_network_interface.dc.private_ip_address
    public_ip  = azurerm_public_ip.dc_public.ip_address
    rdp_command = "mstsc /v:${azurerm_public_ip.dc_public.ip_address}"
  }
}

output "existing_vpn_status" {
  description = "Commands to check existing VPN connections"
  value = {
    check_onprem = "az network vpn-connection show --resource-group rg-hybrid-demo-onprem-eastus --name conn-onprem-to-prod --query connectionStatus"
    check_prod = "az network vpn-connection show --resource-group rg-hybrid-demo-cloud-westus2 --name conn-prod-to-onprem --query connectionStatus"
  }
}

output "resource_groups" {
  description = "Resource groups in use"
  value = {
    onprem = data.azurerm_resource_group.onprem.name
    prod = data.azurerm_resource_group.prod.name
  }
}

output "next_steps" {
  description = "What to deploy next"
  value = {
    message = "Domain Controller will be deployed. Add production services next."
    estimated_cost = "~$3/month for Domain Controller VM"
  }
}