## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.11 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.kubernetes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_project_service.kubernetes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_container_registry_repository.kubernetes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_registry_repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | `string` | `"k8s-terra-cluster"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"k8s-terraform2020"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"northamerica-northeast1"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `"northamerica-northeast1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Public certificate used by clients to authenticate to the cluster endpoint. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Private key used by clients to authenticate to the cluster endpoint. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Public certificate that is the root of trust for the cluster. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The IP address of this cluster's Kubernetes master. |
| <a name="output_gcr_location"></a> [gcr\_location](#output\_gcr\_location) | URL to use for the container registry. |
