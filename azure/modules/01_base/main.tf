#data "external" "rg_check" {
#    program = ["/bin/bash","${path.module}/scripts/rg_check.sh"]
#
#    query = {
#        group_name = var.group_name
#    }
#}
resource "azurerm_resource_group" "rg" {
  #    count             = "${data.external.rg_check.result.exists == "true" ? 0 : 1}"
  #    depends_on        = [data.external.rg_check]
  name     = var.group_name
  location = var.location
  tags = {
    environment = var.env
    project     = var.appName
  }
}