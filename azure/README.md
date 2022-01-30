# Terraform Script for VM deployment
## Description
This contains modules and resources for deploying the following

- Azure VM

    - Nginx for LB
    - Change SSH port
    - Setup NVM, NodeJs and PM2
    - Import SSL cert for Nginx Web server 

- PublicIP
- Import SSL from key Vault
- Export SSH private key to Vault
- Setup DNS A record mapped to the PublicIP

## Usage
Create a file named terrarom.tfvars and populate with information as below.
See the [inputs](./README.md#inputs) in the requirements section for more information
```
image_publisher       = "Canonical"
image_offer           = "UbuntuServer"
image_sku             = "18.04-lts"
computer_name_prefix  = "<prefix>"
admin_username        = "<username>"
resource_group_name   = "<rg>"
ssh_port              = "<port>"
frontend_port         = "<port>"
frontend_url          = "<fqdn>"
api_port              = "<port>"
api_url               = "<fqdn>"
admin_port            = "<port>"
admin_url             = "<fqdn>"
pm2_version           = "5.1.1"
nodejs_version        = "v16.4.0"
subdomains = [
"admin_subdmain_prefix", "api_subdmain_prefix", "frontend_subdmain_prefix"]
```
To deploy environment, ensure you are authenticated with azure cli then
```
./deploy.sh -h 
Usage: ./deploy.sh [-a|--action] [-e|--env]
options:
-a|--action [apply|destroy]     Terraform action to perform 
-e|--env    [dev|staging|prod]  Environment to deploy to.
```
To deploy to specific environment
```
./deploy.sh -a apply -e dev
```

To clean up
```
./deploy.sh -a destroy -e dev
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>2.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.94.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_dns"></a> [azure\_dns](#module\_azure\_dns) | ./modules/04_azure_dns | n/a |
| <a name="module_azure_net"></a> [azure\_net](#module\_azure\_net) | ./modules/02_azure_net | n/a |
| <a name="module_azure_vm"></a> [azure\_vm](#module\_azure\_vm) | ./modules/03_azure_vm | n/a |
| <a name="module_base"></a> [base](#module\_base) | ./modules/01_base | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.rg_create](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_subscriptions.id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_port"></a> [admin\_port](#input\_admin\_port) | port for the admin app | `string` | n/a | yes |
| <a name="input_admin_prefix"></a> [admin\_prefix](#input\_admin\_prefix) | prefix before url for the admin page | `string` | `"admin"` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | default vm username | `string` | `"goodaction"` | no |
| <a name="input_api_port"></a> [api\_port](#input\_api\_port) | port for the api app | `string` | n/a | yes |
| <a name="input_api_prefix"></a> [api\_prefix](#input\_api\_prefix) | prefix before url for the api page | `string` | `"api"` | no |
| <a name="input_appName"></a> [appName](#input\_appName) | Application general name | `string` | `"goodaction"` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | Name of the ssl certs in vault | `string` | `"wildcard-ssl"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | network | `list` | n/a | yes |
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | vm name | `string` | `"vm"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | DNS domain name | `string` | `"goodaction.com"` | no |
| <a name="input_env"></a> [env](#input\_env) | deployment environment | `string` | `"dev"` | no |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | port for the frontend app | `string` | n/a | yes |
| <a name="input_frontend_prefix"></a> [frontend\_prefix](#input\_frontend\_prefix) | prefix before url for the frontend page | `string` | `" "` | no |
| <a name="input_image_offer"></a> [image\_offer](#input\_image\_offer) | azure image offer | `string` | `"UbuntuServer"` | no |
| <a name="input_image_publisher"></a> [image\_publisher](#input\_image\_publisher) | azure image publisher | `string` | `"Canonical"` | no |
| <a name="input_image_sku"></a> [image\_sku](#input\_image\_sku) | azure image version sku | `string` | `"18.04-LTS"` | no |
| <a name="input_location"></a> [location](#input\_location) | Resource Group Location | `string` | `"eastus"` | no |
| <a name="input_nodejs_version"></a> [nodejs\_version](#input\_nodejs\_version) | NodeJs version to setup on VM | `string` | n/a | yes |
| <a name="input_pm2_version"></a> [pm2\_version](#input\_pm2\_version) | pm2 version to setup on VM | `string` | n/a | yes |
| <a name="input_resource_group_name_dns"></a> [resource\_group\_name\_dns](#input\_resource\_group\_name\_dns) | Security resource group name | `string` | `"Goodaction-Prod-Sec"` | no |
| <a name="input_resource_group_name_sec"></a> [resource\_group\_name\_sec](#input\_resource\_group\_name\_sec) | Security resource group name | `string` | `"backend-Sec-RG"` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | SSH port to change to, reduce bruteforce attack on default port 22 | `string` | `"2222"` | no |
| <a name="input_sub_search"></a> [sub\_search](#input\_sub\_search) | subsciption search parameter | `string` | `"POC"` | no |
| <a name="input_subdomains"></a> [subdomains](#input\_subdomains) | List of subdomains to setup on Azure DNS | `list` | <pre>[<br>  "api-prod",<br>  "prod",<br>  "admin-prod"<br>]</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | subnets for resources | `list` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | name of the Azure key vault to retrieve certs | `string` | `"tf-core-backend-kv10063"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | VM size | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP to access APP and VM |
| <a name="output_subdomain_prefix"></a> [subdomain\_prefix](#output\_subdomain\_prefix) | generated fqdn prefix |
