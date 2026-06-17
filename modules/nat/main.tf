resource "azurerm_nat_gateway" "main" {
  name                    = var.nat_name
  location                = var.location_name
  resource_group_name     = var.resourcegroup_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

