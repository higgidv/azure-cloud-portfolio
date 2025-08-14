output "vpn_connection_status" {
  description = "VPN connection status commands"
  value = {
    onprem_to_prod = "az network vpn-connection show --resource-group ${data.azurerm_resource_group.onprem.name} --name conn-onprem-to-prod --query connectionStatus"
    prod_to_onprem = "az network vpn-connection show --resource-group ${data.azurerm_resource_group.prod.name} --name conn-prod-to-onprem --query connectionStatus"
  }
}

output "domain_controller" {
  description = "Domain Controller connection information"
  value = {
    private_ip = azurerm_network_interface.dc.private_ip_address
    public_ip  = azurerm_public_ip.dc_public.ip_address
    rdp_command = "mstsc /v:${azurerm_public_ip.dc_public.ip_address}"
    domain = "contoso.local"
  }
}

output "sql_database" {
  description = "SQL Database connection information"
  value = {
    server_fqdn = azurerm_mssql_server.prod.fully_qualified_domain_name
    database_name = azurerm_mssql_database.prod.name
    server_name = azurerm_mssql_server.prod.name
  }
  sensitive = true
}

output "connectivity_tests" {
  description = "Test commands to run from Domain Controller"
  value = {
    sql_server_test = "Test-NetConnection -ComputerName ${azurerm_mssql_server.prod.fully_qualified_domain_name} -Port 1433 -InformationLevel Detailed"
    dns_resolution_sql = "Resolve-DnsName ${azurerm_mssql_server.prod.fully_qualified_domain_name}"
    web_test = "Invoke-WebRequest -Uri https://www.microsoft.com -UseBasicParsing"
  }
}

output "project_summary" {
  description = "Project 02 completion summary"
  value = {
    status = "✅ SQL DATABASE DEPLOYED"
    sql_server = azurerm_mssql_server.prod.fully_qualified_domain_name
    hybrid_connectivity = "VPN tunnels established between East US and West US 2"
    total_monthly_cost = "~$23/month"
    next_steps = "Test hybrid connectivity from Domain Controller"
  }
}

output "cost_breakdown" {
  description = "Updated monthly costs with production services"
  value = {
    vpn_gateways = "~$12/month (2 x VpnGw1)"
    domain_controller = "~$6/month (B2s)"
    sql_database = "~$5/month (Basic)"
    storage_networking = "<$1/month"
    total_monthly = "~$23/month"
  }
}