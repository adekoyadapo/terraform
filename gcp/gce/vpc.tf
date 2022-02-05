resource "random_id" "vpc_id" {
  byte_length = 2
  prefix      = "vpc-"
  }

resource "google_compute_address" "static" {
  name = "${random_id.vpc_id.hex}-ipv4"
}
resource "google_compute_network" "vpc_network" {
  name    = random_id.vpc_id.hex
}
resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "${random_id.vpc_id.hex}-subnetwork"
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}
resource "google_compute_firewall" "fw" {
  project     = var.project_name 
  name        = "${random_id.vpc_id.hex}-fw"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["22"]
         }
   source_ranges = ["0.0.0.0/0"]
   target_tags = "${var.tags}"
}