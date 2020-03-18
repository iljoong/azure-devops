# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {}
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    environment = var.tag
  }
}

# user assinged identity
resource "azurerm_user_assigned_identity" "tfrg" {
  resource_group_name = azurerm_resource_group.tfrg.name
  location            = azurerm_resource_group.tfrg.location

  name = "${var.prefix}identity"
}

/*
# referencing exisiting user-assigned identity
data "azurerm_user_assigned_identity" "tfrg" {
  name                = "tfidentity"
  resource_group_name = "ikfxurl-rg"
}

# object id
output "user_assigned_identity_sp_id" {
  value = data.azurerm_user_assigned_identity.tfrg.principal_id
}
*/

# Create virtual network
resource "azurerm_virtual_network" "tfvnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.tfrg.name

  tags = {
    environment = var.tag
  }
}

resource "azurerm_subnet" "tfdevvnet" {
  name                 = "dev-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "tfprdvnet" {
  name                 = "prd-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "tfagtvnet" {
  name                 = "agt-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefix       = "10.0.0.0/24"
}
