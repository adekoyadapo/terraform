output "vpc_name" {
    value = google_compute_network.vpc_network.name
    description = "VPC network name"
}
output "subnet_name" {
    value = google_compute_subnetwork.public-subnetwork.name
}
output "public_ip" {
  value = google_compute_address.static.address
}