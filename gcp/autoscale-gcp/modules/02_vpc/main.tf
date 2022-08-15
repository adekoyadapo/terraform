resource "random_id" "id" {
  byte_length = 4
  prefix      = "vpc-"
}
resource "google_compute_network" "vpc_network" {
  name = random_id.id.hex
}
resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "${random_id.id.hex}-subnetwork"
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}
resource "google_compute_firewall" "fw" {
  name        = "${random_id.id.hex}-http-ssh"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.tags
}