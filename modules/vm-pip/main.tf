resource "azurerm_public_ip" "main" {
  name                = var.ubuntu_vm_publicIp_name
  location            = var.location_name
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
}