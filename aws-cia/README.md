## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.pub_static](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.amz-webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.web-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.centos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az"></a> [az](#input\_az) | n/a | `string` | `"us-west-2a"` | no |
| <a name="input_image"></a> [image](#input\_image) | n/a | `string` | `"ami-0c5b0e963f3f41645"` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_ssh_priv"></a> [ssh\_priv](#input\_ssh\_priv) | n/a | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_ssh_pub"></a> [ssh\_pub](#input\_ssh\_pub) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_new_pub_address"></a> [new\_pub\_address](#output\_new\_pub\_address) | EC2 Public IP |
| <a name="output_pub_dns"></a> [pub\_dns](#output\_pub\_dns) | EC2 Public DNS |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.pub_static](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.amz-webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.web-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.centos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az"></a> [az](#input\_az) | n/a | `string` | `"us-west-2a"` | no |
| <a name="input_image"></a> [image](#input\_image) | n/a | `string` | `"ami-0c5b0e963f3f41645"` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_ssh_priv"></a> [ssh\_priv](#input\_ssh\_priv) | n/a | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_ssh_pub"></a> [ssh\_pub](#input\_ssh\_pub) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_new_pub_address"></a> [new\_pub\_address](#output\_new\_pub\_address) | EC2 Public IP |
| <a name="output_pub_dns"></a> [pub\_dns](#output\_pub\_dns) | EC2 Public DNS |
<!-- END_TF_DOCS -->