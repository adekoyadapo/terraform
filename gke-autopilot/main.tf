data "google_client_config" "default" {
}

data "google_project" "project_info" { 
}

resource "google_project_service" "service" {
  project = data.google_project.project_info.id
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com"

  ])
    service = each.key
    disable_on_destroy = false
}

resource "time_sleep" "service_activate" {
  create_duration = "120s"
  depends_on      = [google_project_service.service]
}
resource "random_id" "id" {
  byte_length = 4
  prefix      = "autopilot-"
  }

# GKE cluster
resource "google_container_cluster" "gke_autopilot" {
  depends_on = [time_sleep.service_activate]
  name       = "${random_id.id.hex}-gke"
  location   = var.region
 
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnetwork.name
  # Enable Autopilot for this cluster
  enable_autopilot = true
  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [google_container_cluster.gke_autopilot]
  project_id   = var.project_id
  location     = var.region
  cluster_name = google_container_cluster.gke_autopilot.name
}
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${random_id.id.hex}.config"
}