terraform {
  backend "gcs" {
    bucket = "sada-ade-admin-proj"
    prefix = "terraform-proj/state/autoscale_tfstate"
  }
}
