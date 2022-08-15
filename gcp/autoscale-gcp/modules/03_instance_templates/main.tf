resource "random_id" "id" {
  byte_length = 2
}
resource "google_service_account" "sa" {
  account_id   = "service-account-${random_id.id.hex}"
  display_name = "Service Account Compute"
}

resource "google_project_iam_binding" "sa_iam" {
  count   = length(var.rolesList)
  project = var.project_name
  role    = var.rolesList[count.index]
  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

resource "time_sleep" "wait" {
  create_duration = "30s"
  depends_on      = [google_project_iam_binding.sa_iam]
}
data "google_compute_image" "image" {
  family  = var.image_family
  project = var.image_project
}

resource "google_compute_instance_template" "template" {
  depends_on  = [time_sleep.wait]
  provider    = google-beta
  name        = "template-${random_id.id.hex}"
  description = "This template is used to create server instances."

  tags = var.tags

  labels = var.labels

  instance_description = "server instances"
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = 10
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      network_tier = "STANDARD"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  metadata = {
    startup-script-url = "gs://${var.bucket_id}/startup.sh"
    gcs-bucket         = "gs://${var.bucket_id}"
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name = "igm-${random_id.id.hex}"
  version {
    instance_template = google_compute_instance_template.template.id
  }
  base_instance_name = "bin-${random_id.id.hex}"
  zone               = var.zone
  target_size        = "1"
}

resource "google_compute_autoscaler" "autoscale" {
  provider = google-beta
  name     = "autoscaler-${random_id.id.hex}"
  zone     = var.zone
  target   = google_compute_instance_group_manager.instance_group_manager.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    metric {
      name   = "custom.googleapis.com/appdemo_queue_depth_01"
      target = "150"
      type   = "GAUGE"
    }
  }
}

