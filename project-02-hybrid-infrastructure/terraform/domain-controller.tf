# Network Security Group for Domain Controller
resource "azurerm_network_security_group" "onprem_dc" {
  name                = "nsg-dc-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowDNS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowLDAP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
  }
}

# Public IP for Domain Controller (for management)
resource "azurerm_public_ip" "dc_public" {
  name                = "pip-dc01-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
  }
}

# Network Interface for Domain Controller
resource "azurerm_network_interface" "dc" {
  name                = "nic-dc01-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.onprem_internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = azurerm_public_ip.dc_public.id
  }

  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
  }
}

# Associate NSG to Network Interface
resource "azurerm_network_interface_security_group_association" "dc" {
  network_interface_id      = azurerm_network_interface.dc.id
  network_security_group_id = azurerm_network_security_group.onprem_dc.id
}

# Domain Controller Virtual Machine
resource "azurerm_windows_virtual_machine" "dc" {
  name                = "vm-dc01-onprem"
  location            = data.azurerm_resource_group.onprem.location
  resource_group_name = data.azurerm_resource_group.onprem.name
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.dc.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
  }
}

# Custom Script Extension to Install AD Domain Services
resource "azurerm_virtual_machine_extension" "dc_setup" {
  name                 = "dc-setup"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools; Install-ADDSForest -DomainName 'contoso.local' -SafeModeAdministratorPassword (ConvertTo-SecureString '${var.admin_password}' -AsPlainText -Force) -Force -Confirm:$false\""
    })
  tags = {
    Environment = "Demo"
    Project     = "HybridCloudArchitecture"
  }
}
