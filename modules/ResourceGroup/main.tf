resource "azurerm_resource_group" "main" {
  name     = var.resourcegroup_name
  location = var.location_name
}