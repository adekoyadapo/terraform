data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = var.datacenter_id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = var.datacenter_id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = var.datacenter_id
}

resource "vsphere_virtual_machine" "vm" {
  count = var.instance_count

  name                 = "${var.name}-${count.index + 1}"
  resource_pool_id     = var.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = var.num_cpu
  num_cores_per_socket = var.num_cores_per_socket
  memory               = var.memory
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  folder               = var.folder
  enable_disk_uuid     = "true"

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "${var.name}-${count.index + 1}-disk"
    size             = 20
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.name}-${count.index + 1}"
        time_zone = var.vm_time_zone
        domain    = var.base_domain
      }
      network_interface {
        ipv4_address = "${var.ip_prefix}${count.index + 1}"
        ipv4_netmask = var.vm_cidr
      }
      ipv4_gateway = var.vm_gateway

      # this will to allow to specify multiple values for dns servers
      # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
      # force an interpolation expression to be interpreted as a list by wrapping it
      # in an extra set of list brackets. That form was supported for compatibility in
      # v0.11, but is no longer supported in Terraform v0.12.
      #
      # If the expression in the following list itself returns a list, remove the
      # brackets to avoid interpretation as a list of lists. If the expression
      # returns a single list item then leave it as-is and remove this TODO comment.
      dns_server_list = [var.dns_servers]
      dns_suffix_list = [var.base_domain]
    }
  }
}

