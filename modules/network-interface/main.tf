resource "azurerm_network_interface" "main" {
  name                = var.network_interface_name
  location            = var.location_name
  resource_group_name = var.resourcegroup_name

  ip_configuration {
    name                          = "internal"
    # subnet_id                     = azurerm_subnet.example.id
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }
}