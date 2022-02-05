# Deploying Buildkite agent on Centos7 VM on GCE

## Prerequisite
Ensure you are authenticated to the Project resource and created a bucket to host the startup script
Also ensure to update the backend in `providers.tf` to reflect the remote bucket for the `statefile`

```
# Create the bucket
gsutil mb -p ${PROJECT_NAME} gs://${BUCKET_NAME} 

export BUILDKITE_TOKEN=<token>
export tags='"\ci=true,docker=true,gcp=true\"'
cat > buildkite.sh << EOF
#!/bin/bash
export tags='"ci=true,docker-build=true"'
sudo sh -c 'echo -e "[buildkite-agent]\nname = Buildkite Pty Ltd\nbaseurl = https://yum.buildkite.com/buildkite-agent/stable/x86_64/\nenabled=1\ngpgcheck=0\npriority=1" > /etc/yum.repos.d/buildkite-agent.repo'
sudo yum -y install buildkite-agent
sudo sed -i "s/xxx/${BUILDKITE_TOKEN}/g" /etc/buildkite-agent/buildkite-agent.cfg
echo -e "\ntags=${tags}\ntags-from-gcp=true\ntags-from-gcp-labels=true" | tee -a /etc/buildkite-agent/buildkite-agent.cfg
sudo systemctl enable buildkite-agent && sudo systemctl start buildkite-agent
sudo yum install curl -y
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker buildkite-agent
EOF

```
### Deploy
Create terraform.tfvars with the required content
```
# Exmaple varsfile
project_name      = " "
region            = " "
zone              = " "
credentials_file  = " "
cidr              = " "
labels            = {
                  environment = " "
                  function    = " "
                  }
tags              = ["allow-ssh", "web-server"]
image_family      = " "
image_project     = " "
machine_type         = " "
# required for pulling the startup scripts and compute api actions
rolesList            = [
                        "roles/storage.objectViewer",
                        "roles/compute.admin",
                        "roles/run.admin"
                        ]
```
Run `terraform init`, `terrafrom fmt/plan`, then `terrafrom apply` when satisfied


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.5.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.static](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.fw](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.vm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.public-subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_project_iam_binding.sa_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_service.cloud_resource_manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.compute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [local_file.sshadmin_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.copy_to_bucket](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.remove_artifacts](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.bucket_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.vpc_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [google_client_openid_userinfo.me](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_openid_userinfo) | data source |
| [google_compute_image.image](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_image) | data source |
| [google_project.project_id](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_project.project_info](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | subnet block | `string` | n/a | yes |
| <a name="input_credentials_file"></a> [credentials\_file](#input\_credentials\_file) | credentials file location | `string` | n/a | yes |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | GCE image family | `string` | n/a | yes |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | GCE image project | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | <pre>{<br>  "env": "POC",<br>  "function": "build-agent"<br>}</pre> | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine sizes | `string` | `"f1-micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Project location | `string` | n/a | yes |
| <a name="input_rolesList"></a> [rolesList](#input\_rolesList) | List of roles required by the build agent | `list` | <pre>[<br>  "roles/storage.objectViewer"<br>]</pre> | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | n/a | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Instance template network tags | `list` | <pre>[<br>  "http"<br>]</pre> | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Project location | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | n/a |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | VPC network name |
