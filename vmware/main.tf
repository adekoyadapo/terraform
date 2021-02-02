provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

module "folder" {
  source = "./folder"

  path          = var.cluster_id
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "resource_pool" {
  source = "./resource_pool"

  name            = var.cluster_id
  datacenter_id   = data.vsphere_datacenter.dc.id
  vsphere_cluster = var.vsphere_cluster
}

module "master" {
  source = "./machine"

  name                 = "master"
  instance_count       = var.master_count
  resource_pool_id     = module.resource_pool.pool_id
  folder               = module.folder.path
  datastore            = var.vsphere_datastore
  network              = var.vm_network
  datacenter_id        = data.vsphere_datacenter.dc.id
  template             = var.vm_template
  cluster_domain       = var.cluster_domain
  ip_prefix            = var.master_ip_prefix
  vm_cidr              = var.machine_cidr
  memory               = var.master_memory
  num_cpu              = var.master_num_cpus
  num_cores_per_socket = var.master_num_cpus_socket
  vm_dns_servers       = var.vm_dns_servers
  vm_time_zone         = var.timezone
  vm_gateway           = var.gw
}

module "compute" {
  source = "./machine"

  name                 = "compute"
  instance_count       = var.compute_count
  resource_pool_id     = module.resource_pool.pool_id
  folder               = module.folder.path
  datastore            = var.vsphere_datastore
  network              = var.vm_network
  datacenter_id        = data.vsphere_datacenter.dc.id
  template             = var.vm_template
  cluster_domain       = var.cluster_domain
  ip_prefix            = var.compute_ip_prefix
  vm_cidr              = var.machine_cidr
  memory               = var.compute_memory
  num_cpu              = var.compute_num_cpus
  num_cores_per_socket = var.compute_num_cpus_socket
  vm_dns_servers       = var.vm_dns_servers
  vm_time_zone         = var.timezone
  vm_gateway           = var.gw
}

