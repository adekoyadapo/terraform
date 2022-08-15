terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
}
provider "google" {
  alias   = "tf_admin"
  project = var.admin_project
}