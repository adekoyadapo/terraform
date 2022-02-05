data "google_project" "project_info" {
  provider = google    
}

resource "google_project_service" "service" {
  project = data.google_project.project_info.id
  for_each = toset([
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com"
  ])
    service = each.key
    disable_on_destroy = false
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "google_compute_image" "image" {
  family  = var.image_family
  project = var.image_project
}

resource "random_id" "id" {
  byte_length = 4
  }

resource "local_file" "sshadmin_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${var.project_name}.pem"
  depends_on      = [tls_private_key.ssh]
  file_permission = "0600"
}

data google_client_openid_userinfo me{
}

data google_project "project_id"{
}

resource "google_service_account" "sa" {
  account_id   = "service-account-${random_id.id.hex}"
  display_name = "Service Account"
}

resource "google_project_iam_binding" "sa_iam" {
  count = length(var.rolesList)
  project = data.google_project.project_id.project_id
  role =  var.rolesList[count.index]
  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

resource "google_compute_instance" "vm" {
  depends_on   = [google_compute_address.static,google_storage_bucket.bucket]
  name         = "vm-${random_id.id.hex}"
  machine_type = var.machine_type
  zone         = var.zone

  tags = "${var.tags}"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
      type = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name

  access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
    startup-script-url = "gs://${google_storage_bucket.bucket.name}/buildkite.sh"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }
}
