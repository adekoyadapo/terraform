resource "azurerm_public_ip" "pubip" {
  name                = "${var.env}PubIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  tags = {
    environment = var.env
    project     = var.appName
  }
}


resource "azurerm_network_security_group" "sec" {
  name                = "${var.env}NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH-WEB"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "22", "${var.ssh_port}"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.env
    project     = var.appName
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.env}NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.env}NicConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
  tags = {
    environment = var.env
    project     = var.appName
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "secassos" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.sec.id
}