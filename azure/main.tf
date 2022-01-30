terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.4"
    }
  }
  backend "azurerm" {
        resource_group_name  = "backend-Sec-RG"
        storage_account_name = "tfcorebackendsa10063"
        container_name       = "tfstate"
        key                  = "goodactionpoc.tfstate"
    }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  features {}
  alias = "poc_sub"
  subscription_id = data.azurerm_subscriptions.id.subscriptions[0].subscription_id
}

data "azurerm_subscriptions" "id" {
      display_name_contains = var.sub_search
}
module "base" {
  source              = "./modules/01_base"
  providers = {
    azurerm.poc_sub   = azurerm.poc_sub
   }
  group_name          = "${var.appName}-${var.env}-RG"
  location            = var.location
  env                 = var.env
  appName             = var.appName
}

resource "time_sleep" "rg_create" {
  create_duration = "20s"
  depends_on      = [module.base]
}

resource "random_string" "random" {
  length           = 3
  lower            = true
  special          = false
  upper            = false
  number           = false
}

module "azure_net" {
  depends_on = [module.base,time_sleep.rg_create]
  source              = "./modules/02_azure_net"
  providers = {
    azurerm.poc_sub = azurerm.poc_sub
   }
  group_name          = "${var.appName}-${var.env}-RG"
  location            = var.location
  env                 = var.env
  appName             = var.appName
  cidr                = var.cidr
  subnets             = var.subnets
}

module "azure_vm" {
  depends_on = [module.base,module.azure_net,random_string.random]
  providers = {
    azurerm.poc_sub = azurerm.poc_sub
   }
  source                    = "./modules/03_azure_vm"
  resource_group_name       = "${var.appName}-${var.env}-RG"
  location                  = var.location
  subnet_id                 = module.azure_net.subnet_id
  image_publisher           = var.image_publisher
  image_offer               = var.image_offer
  image_sku                 = var.image_sku
  random_string             = "${random_string.random.id}"
  computer_name             = var.computer_name 
  ssh_port                  = var.ssh_port
  admin_username            = "${var.admin_username}${var.env}"
  nodejs_version            = var.nodejs_version
  pm2_version               = var.pm2_version
  admin_url                 = "${var.admin_prefix}-${var.env}"
  api_url                   = "${var.api_prefix}-${var.env}"
  frontend_url              = var.env
  api_port                  = var.api_port
  admin_port                = var.admin_port
  frontend_port             = var.frontend_port
  vault_name                = var.vault_name
  sec_rg                    = var.resource_group_name_sec
  env                       = var.env
  appName                   = var.appName
  vm_size                   = var.vm_size
  cert_name                 = var.cert_name
}

module "azure_dns" {
  count = length(module.azure_vm.subdomain_prefix)
  source               = "./modules/04_azure_dns"
  providers = {
    azurerm.poc_sub   = azurerm.poc_sub
   }
  subdomains           = "${module.azure_vm.subdomain_prefix}"[count.index]
  resource_group_name  = var.resource_group_name_dns
  pub_ip_id            = module.azure_vm.public_ip_id
  depends_on           = [module.azure_vm]
}