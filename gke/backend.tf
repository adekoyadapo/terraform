terraform {
  # Which versions of the Terraform CLI can be used with the configuration
  required_version = "~> 0.11"
  # Store Terraform state and the history of all revisions remotely, and protect that state with locks to prevent corruption.
  backend "gcs" {
    # The name of the Google Cloud Storage (GCS) bucket
    bucket  = "k8s-terraform2020"
#    project = "k8s-terraform2020"
#    region  = "northamerica-northeast1"
  }
}
