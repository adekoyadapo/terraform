provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
  zone        = var.zone
  project     = var.project_id
}