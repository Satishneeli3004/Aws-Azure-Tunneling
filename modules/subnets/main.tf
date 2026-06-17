resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = var.network_name
  # address_prefixes     = ["192.0.1.0/24"]
  address_prefixes  = var.subnet_range

}