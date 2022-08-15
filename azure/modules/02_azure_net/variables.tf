variable "group_name" {
  description = "name of resource group"
  type        = string
}

variable "env" {
  description = "deployment environment"
  type        = string
}

variable "appName" {
  description = "Application general name"
  type        = string
}
variable "location" {
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
