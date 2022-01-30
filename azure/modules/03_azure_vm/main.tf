resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group_name
  }

  byte_length = 8
}


data "azurerm_key_vault" "vault" {
  name                = var.vault_name
  resource_group_name = var.sec_rg
}

data "azurerm_key_vault_certificate" "cert" {
  name               = var.cert_name
  key_vault_id       = data.azurerm_key_vault.vault.id

}

data "azurerm_key_vault_certificate_data" "pem" {
  name         = var.cert_name
  key_vault_id = data.azurerm_key_vault.vault.id
}


data "template_file" "vm_userdata" {
  template = file("${path.module}/cloudinit.userdata")

  vars = {
    admin_username      = var.admin_username
    nodejs_version      = var.nodejs_version
    pm2_version         = var.pm2_version
    pubkey              = tls_private_key.ssh.public_key_openssh
    ssh_port            = var.ssh_port
    admin_url           = "${var.admin_url}-${var.random_string}.goodaction.com"
    api_url             = "${var.api_url}-${var.random_string}.goodaction.com"
    frontend_url        = "${var.frontend_url}-${var.random_string}.goodaction.com"
    api_port            = var.api_port
    admin_port          = var.admin_port
    frontend_port       = var.frontend_port
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.env}-${var.random_string}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "${var.env}OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  computer_name                   = "${var.env}-${var.random_string}"
  admin_username                  = var.admin_username
  disable_password_authentication = true
  custom_data                     = base64encode(data.template_file.vm_userdata.rendered)

  admin_ssh_key {
    username   = var.admin_username
    public_key = "${trimspace(tls_private_key.ssh.public_key_openssh)} ${var.admin_username}@goodaction.com"
  }

  secret {
    key_vault_id = data.azurerm_key_vault.vault.id
    certificate {
     url    = data.azurerm_key_vault_certificate.cert.secret_id
     }
  }
 
  depends_on = [tls_private_key.ssh]

  tags         = {
                  environment = var.env
                  project     = var.appName
            }
}
resource "local_file" "sshadmin_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${var.admin_username}.pem"
  depends_on      = [tls_private_key.ssh]
  file_permission = "0600"
}

resource "azurerm_key_vault_secret" "admin_pem" {
  name         = "${var.admin_username}"
  value        = tls_private_key.ssh.private_key_pem
  key_vault_id = data.azurerm_key_vault.vault.id

  tags         = {
                  environment = var.env
                  project     = var.appName
            }

}