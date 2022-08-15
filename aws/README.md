## Requirements

Set up terraform cloud as backend remote [here](https://www.terraform.io/language/settings/backends/remote)

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.amz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ca-central-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_priv_address"></a> [priv\_address](#output\_priv\_address) | EC2 internal IP |
| <a name="output_pub_address"></a> [pub\_address](#output\_pub\_address) | EC2 Public Elastic IP |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.amz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ca-central-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_priv_address"></a> [priv\_address](#output\_priv\_address) | EC2 internal IP |
| <a name="output_pub_address"></a> [pub\_address](#output\_pub\_address) | EC2 Public Elastic IP |
<!-- END_TF_DOCS -->