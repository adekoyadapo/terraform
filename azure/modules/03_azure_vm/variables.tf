variable "resource_group_name" {
    type = string
}
variable "location" {
    type = string
}
variable "image_publisher" {
    type = string
}
variable "image_offer" {
    type = string
}
variable "image_sku" {
    type = string
}
variable "computer_name" {
    type = string
}
variable "admin_username" {
    type = string
}
variable "subnet_id" {
}

variable "image_version" {
    type = string
    default = "latest"
}

variable "ssh_port" {
    type = string
    default = "2222"
}
variable "nodejs_version" {
}

variable "pm2_version" {
}
variable "admin_url" {
}
variable "admin_port" {
}
variable "api_url" {
}
variable "api_port" {
}
variable "frontend_url" {
}
variable "frontend_port" {
}
variable "vault_name" {
    type = string
}
variable "cert_name" {
    type = string
}
variable "sec_rg" {
    type = string
}
variable "appName" {
    type = string
}
variable "env" {
    type = string
}
variable "vm_size" {
    type = string
}
variable "random_string" {
    type = string
    description = "random 3 alphabets"
}