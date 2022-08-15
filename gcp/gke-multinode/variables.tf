variable "project_id" {
  description = "projectname"
  default     = "sada-ade-admin-proj"
}
variable "network_name" {
  default     = "demo"
  description = "network name"
}

variable "subnet_name" {
  default     = "demo-subnet"
  description = "subnet name"
}

variable "vpc_1_ip_range" {
  default     = "10.10.0.0/16"
  description = "network cidr and subnet cidr"
}

variable "region" {
  default     = "us-west1"
  description = "region"
}

variable "rolesList" {
  type        = list(any)
  description = "List of roles required by the build agent"
  default     = ["roles/storage.objectViewer"]
}

variable "node_pool_1" {
  default     = "app-1"
  description = "node pool name"
}

variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources = list(object({
      resource_type = string
      minimum       = number
      maximum       = number
    }))
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
    gpu_resources       = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}