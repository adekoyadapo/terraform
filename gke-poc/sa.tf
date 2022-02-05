resource "random_id" "id" {
  byte_length = 4
  }

resource "google_service_account" "sa" {
  account_id   = "service-account-${random_id.id.hex}"
  display_name = "Service Account"
}

resource "google_project_iam_binding" "sa_iam" {
  count = length(var.rolesList)
  project = var.project_id
  role =  var.rolesList[count.index]
  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

