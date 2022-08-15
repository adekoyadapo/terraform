# Terraform base scripts for various projects
## Description
Terraform setups and scripts for various projects and tasks
### Directory Structure
```
.
├── aws
├── aws-cia
├── azure
│   ├── env-vars
│   └── modules
│       ├── 01_base
│       │   └── scripts
│       ├── 02_azure_net
│       ├── 03_azure_vm
│       └── 04_azure_dns
├── docker
├── gcp
│   ├── autoscale-gcp
│   │   └── modules
│   │       ├── 01_storage
│   │       ├── 02_vpc
│   │       └── 03_instance_templates
│   ├── cloudfunction
│   │   ├── terraform
│   │   │   └── stateful
│   │   └── test
│   ├── cloudrun
│   ├── cloudrun-apigateway-terraform
│   │   ├── locations
│   │   │   └── api
│   │   ├── terraform
│   │   │   └── stateful
│   │   │       └── scripts
│   │   └── users
│   │       └── api
│   ├── dynamic-serverless
│   ├── gce
│   ├── gke-multinode
│   └── org
├── gke
├── gke-autopilot
├── gke-poc
├── kubernetes
│   ├── echo-test
│   └── nginx-scale
├── packer
│   └── packer-CentOS8
│       ├── http
│       └── scripts
└── vmware
    ├── folder
    ├── machine
    ├── parker
    │   ├── centos7
    │   ├── centos8
    │   ├── centos8-gui
    │   ├── ubuntu18
    │   └── ubuntu18-cloudinit
    └── resource_pool
```
## Deploying Infrastructure
For more information on leveraging this resource visit individual sections README.md files.

* [aws](./aws/README.md) [aws-cia](./aws-cia/README.md)
* [azure](./azure/README.md)
* [docker](./docker/README.md)
* [gke](./gke/README.md)
* [k8s-echo-test](./kubernetes/echo-test/README.md) [k8s-nginx](./kubernetes/nginx-scale/README.md)
* [vmware](./vmware/README.md)
