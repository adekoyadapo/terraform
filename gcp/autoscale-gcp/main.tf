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

provider "google-beta" {
  credentials = file(var.credentials_file)
  region = var.region
  zone   = var.zone
  project     = var.project_name
}

data "google_project" "project_info" {
  provider = google    
}

resource "google_project_service" "service" {
  project = data.google_project.project_info.id
  for_each = toset([
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

module "storage" {
  source       = "./modules/01_storage"
  region       = var.region
  project      = var.project_name
  url          = var.url
  org_id       = var.org_id
  bucket_name  = var.bucket_name
}
module "vpc" {
  source       = "./modules/02_vpc"
  region       = var.region
  cidr         = var.cidr
  tags         = "${var.tags}"
}
module "instance_template"{
  source               = "./modules/03_instance_templates"
  bucket_id            = module.storage.storage_bucket_id
  tags                 = "${var.tags}"
  zone                 = var.zone
  labels               = var.labels
  machine_type         = var.machine_type
  image_family         = var.image_family
  image_project        = var.image_project
  network              = module.vpc.vpc_name
  subnetwork           = module.vpc.subnet_name
  project_name         = var.project_name
  rolesList            = var.rolesList
}
