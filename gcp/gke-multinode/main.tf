data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 4.0"
  project_id              = var.project_id
  network_name            = var.network_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name           = var.subnet_name
      subnet_ip             = cidrsubnet("${var.vpc_1_ip_range}", 6, 0)
      subnet_region         = var.region
      subnet_private_access = "false"
    },
  ]

  secondary_ranges = {
    (var.subnet_name) = [
      {
        range_name    = "${var.subnet_name}-a-pods"
        ip_cidr_range = cidrsubnet("${var.vpc_1_ip_range}", 6, 1)
      },
      {
        range_name    = "${var.subnet_name}-a-services"
        ip_cidr_range = cidrsubnet("${var.vpc_1_ip_range}", 8, 128)
      },
    ]
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_service_account" "cluster-serviceaccount" {
  account_id   = "gke-sa-demo-${random_string.suffix.result}"
  display_name = "Service Account For Terraform To Make GKE Cluster"
  project      = var.project_id
}

resource "google_project_iam_binding" "sa_iam" {
  count   = length(var.rolesList)
  project = var.project_id
  role    = var.rolesList[count.index]
  members = [
    "serviceAccount:${google_service_account.cluster-serviceaccount.email}",
  ]
}

module "gke" {
  depends_on = [
    module.vpc,
    google_service_account.cluster-serviceaccount
  ]
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "~> 22.0.0"
  project_id                 = var.project_id
  name                       = "demo-${random_string.suffix.result}"
  regional                   = true
  region                     = var.region
  network                    = module.vpc.network.network.name
  subnetwork                 = var.subnet_name
  ip_range_pods              = module.vpc.subnets_secondary_ranges[0].0.range_name
  ip_range_services          = module.vpc.subnets_secondary_ranges[0].1.range_name
  create_service_account     = false
  service_account            = google_service_account.cluster-serviceaccount.email
  skip_provisioners          = true
  horizontal_pod_autoscaling = true
  cluster_autoscaling        = var.cluster_autoscaling
  node_pools = [
    {
      name                       = var.node_pool_1
      machine_type               = "e2-medium"
      min_count                  = 1
      max_count                  = 3
      local_ssd_count            = 0
      spot                       = false
      disk_size_gb               = 50
      disk_type                  = "pd-standard"
      image_type                 = "COS_CONTAINERD"
      enable_gcfs                = false
      enable_gvnic               = false
      auto_repair                = true
      auto_upgrade               = true
      service_account            = google_service_account.cluster-serviceaccount.email
      preemptible                = false
      initial_node_count         = 1
      horizontal_pod_autoscaling = true
    },
  ]
  remove_default_node_pool = true
  node_pools_oauth_scopes = {
    all = []

    "${var.node_pool_1}" = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {
      "environment" = "poc"
    }

    "${var.node_pool_1}" = {
      "application-name" = "app-1"
    }
  }

  node_pools_metadata = {
    all = {}

    "${var.node_pool_1}" = {
      node-pool-metadata-custom-value = "app-1"
    }
  }

  node_pools_taints = {
    all = [
    ]

    "${var.node_pool_1}" = [
      {
        key    = "application"
        value  = "app-1"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []
  }
}


module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = "~> 22.0.0"
  depends_on           = [module.gke]
  project_id           = var.project_id
  cluster_name         = module.gke.name
  location             = module.gke.location
  use_private_endpoint = true
}

resource "local_file" "kubeconfig" {
  depends_on = [
    module.gke_auth
  ]
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
}
