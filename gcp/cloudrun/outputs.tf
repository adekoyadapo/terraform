output "service_name" {
  value       = google_cloud_run_service.service.name
  description = "Name of the created service"
}

output "service_location" {
  value       = google_cloud_run_service.service.location
  description = "Location in which the Cloud Run service was created"
}
output "service_url" {
  value = google_cloud_run_service.service.status[0].url
}