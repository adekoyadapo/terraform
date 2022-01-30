output "tls_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
  description = "private key to access VM"
}

output "public_ip" {
  value = azurerm_public_ip.pubip.ip_address
  description = "VM public IP"
}

output "public_ip_id" {
  value = azurerm_public_ip.pubip.id
}
output "subdomain_prefix" {
  description = "generated fqdn prefix"
  value = [
    "${var.admin_url}-${var.random_string}",
    "${var.api_url}-${var.random_string}",
    "${var.frontend_url}-${var.random_string}"      
  ]
}