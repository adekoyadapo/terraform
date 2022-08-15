data "terraform_remote_state" "staging_cloudfunction" {
  backend = "gcs"
  config = {
    bucket = "maropost-commerce-staging-terraform-state"
    prefix = "cloudfunction"
  }
}
data "terraform_remote_state" "production_cloudfunction" {
  backend = "gcs"
  config = {
    bucket = "maropost-commerce-production-terraform-state"
    prefix = "cloudfunction"
  }
}
