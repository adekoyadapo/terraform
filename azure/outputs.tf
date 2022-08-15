output "public_ip" {
  value       = module.azure_vm.public_ip
  description = "Public IP to access APP and VM"
}
output "subdomain_prefix" {
  value       = [module.azure_vm.subdomain_prefix]
  description = "generated fqdn prefix"
}