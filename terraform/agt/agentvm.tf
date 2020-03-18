# Create Network Security Group and rule
resource "azurerm_network_security_group" "tfagtnsg" {
  name                = "${var.prefix}-agtnsg"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*" # add source addr
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.tag
  }
}

# Create public IPs
resource "azurerm_public_ip" "tfagtip" {
  name                = "${var.prefix}-agtip"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"

  #domain_name_label   = "${var.prefix}agt"

  tags = {
    environment = var.tag
  }
}

# Create network interface
resource "azurerm_network_interface" "tfagtnic" {
  name                      = "${var.prefix}-agtnic"
  location                  = var.location
  resource_group_name       = var.rgname
  #network_security_group_id = azurerm_network_security_group.tfagtnsg.id

  ip_configuration {
    name                          = "${var.prefix}-agtnic-conf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.tfagtip.id
  }

  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_interface_security_group_association" "tfagtnic" {
  network_interface_id      = azurerm_network_interface.tfagtnic.id
  network_security_group_id = azurerm_network_security_group.tfagtnsg.id
}

# Create virtual machine
resource "azurerm_virtual_machine" "tfagtvm" {
  name                  = "${var.prefix}agentvm"
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.tfagtnic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.prefix}-ftosdisk-agt"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "agentvm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {

  }

  tags = {
    environment = var.tag
  }
}

# public_ip must be 'static' in order to print output properly 
output "agentvm_ip" {
  value = azurerm_public_ip.tfagtip.ip_address
}

