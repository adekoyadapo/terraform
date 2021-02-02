variable "name" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "resource_pool_id" {
  type = string
}

variable "folder" {
  type = string
}

variable "datastore" {
  type = string
}

variable "network" {
  type = string
}

variable "cluster_domain" {
  type = list(string)
}

variable "datacenter_id" {
  type = string
}

variable "template" {
  type = string
}

#variable "machine_cidr" {
#  type = "string"
#}

variable "ip_prefix" {
  type = string
}

variable "memory" {
  type = string
}

variable "num_cpu" {
  type = string
}

variable "num_cores_per_socket" {
  type = string
}

variable "vm_cidr" {
  type = string
}

variable "vm_dns_servers" {
  type = list(string)
}

variable "vm_time_zone" {
  type = string
}

variable "vm_gateway" {
  type = string
}

variable "base_domain" {
  type    = string
  default = "ace.home"
}

variable "dns_servers" {
  type    = string
  default = "10.0.0.168"
}
