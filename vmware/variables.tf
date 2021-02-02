//////
// vSphere variables
//////

variable "vsphere_server" {
  type        = string
  description = "This is the vSphere server for the environment."
}

variable "vsphere_user" {
  type        = string
  description = "vSphere server user for the environment."
}

variable "vsphere_password" {
  type        = string
  description = "vSphere server password"
}

variable "vsphere_cluster" {
  type        = string
  description = "This is the name of the vSphere cluster."
}

variable "vsphere_datacenter" {
  type        = string
  description = "This is the name of the vSphere data center."
}

variable "vsphere_datastore" {
  type        = string
  description = "This is the name of the vSphere data store."
}

variable "vm_template" {
  type        = string
  description = "This is the name of the VM template to clone."
}

variable "vm_network" {
  type        = string
  description = "This is the name of the publicly accessible network for cluster ingress and access."
  default     = "VM Network"
}

/////////
// cluster variables
/////////

variable "cluster_id" {
  type        = string
  description = "This cluster id must be of max length 27 and must have only alphanumeric or hyphen characters."
}

variable "base_domain" {
  type        = string
  description = "The base DNS zone to add the sub zone to."
}

variable "cluster_domain" {
  type        = list(string)
  description = "The base DNS zone to add the sub zone to."
}

variable "machine_cidr" {
  type    = string
  default = "24"
}

variable "vm_dns_servers" {
  type    = list(string)
  default = ["10.0.0.168", "10.0.0.1"]
}

variable "timezone" {
  type    = string
  default = "America/Edmonton"
}

variable "gw" {
  type    = string
  default = "10.0.0.1"
}

///////////
// Master machine variables
///////////

variable "master_count" {
  type    = string
  default = "3"
}

variable "master_ip_prefix" {
  type    = string
  default = "10.0.0.2"
}

variable "master_memory" {
  type    = string
  default = "2048"
}

variable "master_num_cpus" {
  type    = string
  default = "2"
}

variable "master_num_cpus_socket" {
  type    = string
  default = "2"
}

//////////
// Compute machine variables
//////////

variable "compute_count" {
  type    = string
  default = "2"
}

variable "compute_ip_prefix" {
  type    = string
  default = "10.0.0.3"
}

variable "compute_memory" {
  type    = string
  default = "2048"
}

variable "compute_num_cpus" {
  type    = string
  default = "2"
}

variable "compute_num_cpus_socket" {
  type    = string
  default = "2"
}

