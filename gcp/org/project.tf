resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  folder_id       = var.folder_id
#  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "container.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

data "google_service_account" "tf_admin" {
  depends_on = [
    google_project.project
  ]
  account_id = var.account_id
  project    = var.admin_project
}

resource "google_project_iam_binding" "project" {
  project = google_project.project.project_id
  role    = "roles/editor"

  members = [
    "serviceAccount:${data.google_service_account.tf_admin.email}",
  ]
}