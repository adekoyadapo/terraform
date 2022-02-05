output "project_id" {
    value = google_project.project.project_id
}
output "sa_email" {
  value = data.google_service_account.tf_admin.email
}