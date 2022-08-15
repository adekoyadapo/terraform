terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.3.0" # static due to Error 400: Max pods constraint on node pools for Autopilot clusters should be 32
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
  project     = var.project_id
}
provider "google-beta" {
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
  project     = var.project_id
}

#provider "kubernetes" {
#  host                   = "https://${google_container_cluster.gke_autopilot.endpoint}"
#  token                  = data.google_client_config.default.access_token
##  client_key             = "base64decode(${google_container_cluster.gke_autopilot.master_auth.0.client_key})"
##  client_certificate     = "base64decode(${google_container_cluster.gke_autopilot.master_auth.0.client_certificate})"
#  cluster_ca_certificate = "base64decode(${google_container_cluster.gke_autopilot.master_auth.0.cluster_ca_certificate})"
#}
