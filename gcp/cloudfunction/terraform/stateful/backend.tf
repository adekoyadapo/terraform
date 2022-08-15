terraform {
  backend "gcs" {
    bucket = "sada-ade-marapost-poc-7cbdc8a2"
    prefix = "terraform-proj/state/cloudfunction_tfstate"
  }
}
