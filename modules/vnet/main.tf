# Create a virtual network within the resource group
resource "azurerm_virtual_network" "main" {
  name                = var.network_name
  resource_group_name = var.resourcegroup_name
  location            = var.location_name
  address_space       = ["192.0.0.0/16"]
}