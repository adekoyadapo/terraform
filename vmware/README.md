## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute"></a> [compute](#module\_compute) | ./machine | n/a |
| <a name="module_folder"></a> [folder](#module\_folder) | ./folder | n/a |
| <a name="module_master"></a> [master](#module\_master) | ./machine | n/a |
| <a name="module_resource_pool"></a> [resource\_pool](#module\_resource\_pool) | ./resource_pool | n/a |

## Resources

| Name | Type |
|------|------|
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | The base DNS zone to add the sub zone to. | `string` | n/a | yes |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The base DNS zone to add the sub zone to. | `list(string)` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | This cluster id must be of max length 27 and must have only alphanumeric or hyphen characters. | `string` | n/a | yes |
| <a name="input_compute_count"></a> [compute\_count](#input\_compute\_count) | n/a | `string` | `"2"` | no |
| <a name="input_compute_ip_prefix"></a> [compute\_ip\_prefix](#input\_compute\_ip\_prefix) | n/a | `string` | `"10.0.0.3"` | no |
| <a name="input_compute_memory"></a> [compute\_memory](#input\_compute\_memory) | n/a | `string` | `"2048"` | no |
| <a name="input_compute_num_cpus"></a> [compute\_num\_cpus](#input\_compute\_num\_cpus) | n/a | `string` | `"2"` | no |
| <a name="input_compute_num_cpus_socket"></a> [compute\_num\_cpus\_socket](#input\_compute\_num\_cpus\_socket) | n/a | `string` | `"2"` | no |
| <a name="input_gw"></a> [gw](#input\_gw) | n/a | `string` | `"10.0.0.1"` | no |
| <a name="input_machine_cidr"></a> [machine\_cidr](#input\_machine\_cidr) | n/a | `string` | `"24"` | no |
| <a name="input_master_count"></a> [master\_count](#input\_master\_count) | n/a | `string` | `"3"` | no |
| <a name="input_master_ip_prefix"></a> [master\_ip\_prefix](#input\_master\_ip\_prefix) | n/a | `string` | `"10.0.0.2"` | no |
| <a name="input_master_memory"></a> [master\_memory](#input\_master\_memory) | n/a | `string` | `"2048"` | no |
| <a name="input_master_num_cpus"></a> [master\_num\_cpus](#input\_master\_num\_cpus) | n/a | `string` | `"2"` | no |
| <a name="input_master_num_cpus_socket"></a> [master\_num\_cpus\_socket](#input\_master\_num\_cpus\_socket) | n/a | `string` | `"2"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | n/a | `string` | `"America/Edmonton"` | no |
| <a name="input_vm_dns_servers"></a> [vm\_dns\_servers](#input\_vm\_dns\_servers) | n/a | `list(string)` | <pre>[<br>  "10.0.0.168",<br>  "10.0.0.1"<br>]</pre> | no |
| <a name="input_vm_network"></a> [vm\_network](#input\_vm\_network) | This is the name of the publicly accessible network for cluster ingress and access. | `string` | `"VM Network"` | no |
| <a name="input_vm_template"></a> [vm\_template](#input\_vm\_template) | This is the name of the VM template to clone. | `string` | n/a | yes |
| <a name="input_vsphere_cluster"></a> [vsphere\_cluster](#input\_vsphere\_cluster) | This is the name of the vSphere cluster. | `string` | n/a | yes |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | This is the name of the vSphere data center. | `string` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | This is the name of the vSphere data store. | `string` | n/a | yes |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | vSphere server password | `string` | n/a | yes |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | This is the vSphere server for the environment. | `string` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | vSphere server user for the environment. | `string` | n/a | yes |

## Outputs

No outputs.
