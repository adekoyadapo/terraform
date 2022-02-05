output "vpc_name" {
    value = google_compute_network.vpc_network.name
    description = "VPN network name"
}
output "subnet_name" {
    value = google_compute_subnetwork.public-subnetwork.name
}