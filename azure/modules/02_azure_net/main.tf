resource "azurerm_virtual_network" "main" {
  name                = "${var.env}Vnet"
  address_space       = var.cidr
  location            = var.location
  resource_group_name = var.group_name
  tags = {
    environment = var.env
    project     = var.appName
  }
}

resource "azurerm_subnet" "main" {
  name                 = "${var.env}Subnet"
  resource_group_name  = var.group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnets
}