resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "random_id" "id" {
  depends_on = [google_project_service.run_api]
  byte_length = 4
  prefix      = "cloudrun-"
  }

resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service" "service" {
  name      = random_id.id.hex
  location  = var.region
  project   = var.project_id
  template {
    spec {
      container_concurrency = 250
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        resources {
          limits = {
              memory = "128Mi"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "10"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}