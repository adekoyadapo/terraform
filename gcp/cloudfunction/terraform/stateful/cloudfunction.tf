resource "random_id" "id" {
  byte_length = 4
}
resource "google_service_account" "cloudfunction_sa" {
  account_id   = "${random_id.id.hex}-sa"
  display_name = "Key Cloud Function SA"
  project      = var.project_id
}

# Create custom role with  IAM privilages needed to list backend buckets and add signed URL key
resource "google_project_iam_custom_role" "cloudfunction_role" {
  role_id     = "cloudfunction_role"
  project     = var.project_id
  title       = "Cloud Function Role"
  description = "Role with permissions to list and add signed URL keys to backend buckets"
  permissions = ["compute.backendBuckets.addSignedUrlKey", "compute.backendBuckets.list"]
}

# Assign custom role to cloud function service account
resource "google_project_iam_member" "cloudfunction_sa_iam" {
  member  = "serviceAccount:${google_service_account.cloudfunction_sa.email}"
  project = var.project_id
  role    = google_project_iam_custom_role.cloudfunction_role.name
}

# Create zip file of cloud function source code
data "archive_file" "cloudfunction_zip" {
  type        = "zip"
  output_path = "${path.module}/cloudfunction.zip"
  source_dir  = "../../."
  excludes    = ["terraform", ".git", ".gitignore"]
}

# Create bucket needed to store cloud function code
resource "google_storage_bucket" "cloudfunction_bucket" {
  name     = "${var.project_id}-${random_id.id.hex}"
  location = var.region
  project  = var.project_id
}

# Upload zipped cloud function code to bucket
resource "google_storage_bucket_object" "archive" {
  name   = "cloudfunction.zip"
  bucket = google_storage_bucket.cloudfunction_bucket.name
  source = data.archive_file.cloudfunction_zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = "PHP Cloudfunction POC"
  runtime     = "php74"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloudfunction_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  service_account_email = google_service_account.cloudfunction_sa.email
  max_instances         = "100"
  timeout               = "60"
  entry_point           = var.function_name
  labels                = var.cost_centre
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
output "function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}