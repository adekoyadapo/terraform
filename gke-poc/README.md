## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.9.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-network"></a> [gcp-network](#module\_gcp-network) | terraform-google-modules/network/google | >= 4.0.1, < 5.0.0 |
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | n/a |
| <a name="module_gke_auth"></a> [gke\_auth](#module\_gke\_auth) | terraform-google-modules/kubernetes-engine/google//modules/auth | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_binding.sa_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_service_account.sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name for the GKE cluster | `string` | `"gke-on-vpc-cluster"` | no |
| <a name="input_credentials_file"></a> [credentials\_file](#input\_credentials\_file) | credentials file location | `string` | n/a | yes |
| <a name="input_ip_range_pods_name"></a> [ip\_range\_pods\_name](#input\_ip\_range\_pods\_name) | The secondary ip range to use for pods | `string` | `"ip-range-pods"` | no |
| <a name="input_ip_range_services_name"></a> [ip\_range\_services\_name](#input\_ip\_range\_services\_name) | The secondary ip range to use for services | `string` | `"ip-range-scv"` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network created to host the cluster in | `string` | `"gke-network"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the cluster in | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host the cluster in | `string` | `"us-central1"` | no |
| <a name="input_rolesList"></a> [rolesList](#input\_rolesList) | List of roles required by the build agent | `list` | <pre>[<br>  "roles/storage.objectViewer"<br>]</pre> | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork created to host the cluster in | `string` | `"gke-subnet"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Project location | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_range_pods_name"></a> [ip\_range\_pods\_name](#output\_ip\_range\_pods\_name) | The secondary IP range used for pods |
| <a name="output_ip_range_services_name"></a> [ip\_range\_services\_name](#output\_ip\_range\_services\_name) | The secondary IP range used for services |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_master_kubernetes_version"></a> [master\_kubernetes\_version](#output\_master\_kubernetes\_version) | The master Kubernetes version |
| <a name="output_network"></a> [network](#output\_network) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_subnetwork"></a> [subnetwork](#output\_subnetwork) | n/a |
| <a name="output_zones"></a> [zones](#output\_zones) | List of zones in which the cluster resides |
