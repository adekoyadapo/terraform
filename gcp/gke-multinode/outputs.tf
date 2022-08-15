output "vpc_name" {
  value = module.vpc.network.network.name
}

output "subnets_sec" {
  value = module.vpc.subnets_secondary_ranges
}

output "kconfig" {
  value     = module.gke_auth.kubeconfig_raw
  sensitive = true
}