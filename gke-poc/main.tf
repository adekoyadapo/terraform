data "google_client_config" "default" {}

#provider "kubernetes" {
#  host                   = "https://${module.gke.endpoint}"
#  token                  = data.google_client_config.default.access_token
#  client_key             = base64decode(module.gke.client_key)
#  client_certificate     = base64decode(module.gke.client_certificate) 
#  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
#}

module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

  project_id   = var.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name   = var.subnetwork
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    (var.subnetwork) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  project_id             = var.project_id
  name                   = var.cluster_name
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  create_service_account = false
  #  service_account        = "${google_service_account.sa.email}"
  horizontal_pod_autoscaling = true
  remove_default_node_pool   = true
  node_pools = [
    {
      name            = "node-pool-01"
      machine_type    = "n1-standard-2"
      min_count       = 1
      max_count       = 5
      local_ssd_count = 0
      disk_size_gb    = 20
      disk_type       = "pd-standard"
      image_type      = "COS_CONTAINERD"
      auto_repair     = false
      auto_upgrade    = true
      #    service_account           = "${google_service_account.sa.email}"
      preemptible        = false
      initial_node_count = 1
    },
  ]
  node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}


module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = var.region
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  depends_on = [
    module.gke_auth
  ]
  content         = module.gke_auth.kubeconfig_raw
  filename        = "kubeconfig-${random_id.id.hex}.config"
  file_permission = 600
}