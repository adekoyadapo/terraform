provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
  project     = var.project_id
}