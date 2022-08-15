variable "sub_search" {
  default     = "POC"
  description = "subsciption search parameter"
  type        = string
}
variable "env" {
  default     = "dev"
  description = "deployment environment"
  type        = string
}

variable "appName" {
  default     = "goodaction"
  description = "Application general name"
  type        = string
}
variable "location" {
  default     = "eastus"
  description = "Resource Group Location"
  type        = string
}
variable "cidr" {
  description = "network"
  type        = list(any)
}

variable "subnets" {
  description = "subnets for resources"
  type        = list(any)
}

variable "domain" {
  type        = string
  default     = "goodaction.com"
  description = "DNS domain name"
}
variable "image_publisher" {
  type        = string
  description = "azure image publisher"
  default     = "Canonical"
}
variable "image_offer" {
  type        = string
  description = "azure image offer"
  default     = "UbuntuServer"
}
variable "image_sku" {
  type        = string
  description = "azure image version sku"
  default     = "18.04-LTS"
}
variable "computer_name" {
  type        = string
  description = "vm name"
  default     = "vm"
}
variable "admin_username" {
  type        = string
  description = "default vm username"
  default     = "goodaction"
}

variable "ssh_port" {
  type        = string
  description = "SSH port to change to, reduce bruteforce attack on default port 22"
  default     = "2222"
}
variable "vault_name" {
  type        = string
  description = "name of the Azure key vault to retrieve certs"
  default     = "tf-core-backend-kv10063"
}
variable "cert_name" {
  type        = string
  description = "Name of the ssl certs in vault"
  default     = "wildcard-ssl"
}
variable "resource_group_name_sec" {
  type        = string
  description = "Security resource group name"
  default     = "backend-Sec-RG"
}
variable "resource_group_name_dns" {
  type        = string
  description = "Security resource group name"
  default     = "Goodaction-Prod-Sec"
}

variable "nodejs_version" {
  type        = string
  description = "NodeJs version to setup on VM"
}

variable "pm2_version" {
  type        = string
  description = "pm2 version to setup on VM"
}
variable "admin_prefix" {
  type        = string
  description = "prefix before url for the admin page"
  default     = "admin"
}
variable "admin_port" {
  type        = string
  description = "port for the admin app"
}
variable "api_prefix" {
  type        = string
  description = "prefix before url for the api page"
  default     = "api"
}
variable "api_port" {
  type        = string
  description = "port for the api app"
}
variable "frontend_prefix" {
  type        = string
  description = "prefix before url for the frontend page"
  default     = " "
}
variable "frontend_port" {
  type        = string
  description = "port for the frontend app"
}
variable "subdomains" {
  type        = list(any)
  description = "List of subdomains to setup on Azure DNS"
  default     = ["api-prod", "prod", "admin-prod"]
}
variable "vm_size" {
  type        = string
  description = "VM size"
}