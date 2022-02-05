## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance_template"></a> [instance\_template](#module\_instance\_template) | ./modules/03_instance_templates | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/01_storage | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/02_vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.project_info](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | Storage for startup script | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | GCS bucket for artifacts name | `string` | `""` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | subnet block | `string` | n/a | yes |
| <a name="input_credentials_file"></a> [credentials\_file](#input\_credentials\_file) | credentials file location | `string` | n/a | yes |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | GCE image family | `string` | n/a | yes |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | GCE image project | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | <pre>{<br>  "env": "POC",<br>  "function": "build-agent"<br>}</pre> | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine sizes | `string` | `"f1-micro"` | no |
| <a name="input_network"></a> [network](#input\_network) | VPC to use | `string` | `"default"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | org/folder id | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Project location | `string` | n/a | yes |
| <a name="input_rolesList"></a> [rolesList](#input\_rolesList) | List of roles required by the build agent | `list` | <pre>[<br>  "roles/storage.objectViewer"<br>]</pre> | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnet to use | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Instance template network tags | `list` | <pre>[<br>  "http"<br>]</pre> | no |
| <a name="input_url"></a> [url](#input\_url) | github url | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Project location | `string` | n/a | yes |

## Outputs

No outputs.
