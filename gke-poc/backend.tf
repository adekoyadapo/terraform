terraform {
  backend "gcs" {
    bucket = "sada-ade-admin-proj"
    prefix = "terraform-proj/state/buildkite_gke_tfstate"
  }
}
