data "azurerm_dns_zone" "parent" {
  name                = "goodaction.com"
  resource_group_name = var.resource_group_name
}

output "dns_zone_id" {
  value = data.azurerm_dns_zone.parent.id
}

resource "azurerm_dns_a_record" "endpoint" {
  name                = var.subdomains
  zone_name           = data.azurerm_dns_zone.parent.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  target_resource_id  = var.pub_ip_id
}