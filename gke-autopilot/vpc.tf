resource "random_id" "vpc_id" {
  byte_length = 2
  prefix      = "vpc-"
  }

resource "google_compute_network" "vpc_network" {
  name    = random_id.vpc_id.hex
}
resource "google_compute_subnetwork" "subnetwork" {
  name          = "${random_id.vpc_id.hex}-subnetwork"
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}