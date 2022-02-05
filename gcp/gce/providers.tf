terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version =  "~>4.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
  project     = var.project_name
}

resource "google_project_service" "cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}