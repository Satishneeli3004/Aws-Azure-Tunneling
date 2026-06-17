resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_machine_name
  resource_group_name = var.resourcegroup_name
  location            = var.location_name
  size                = "Standard_D4_v5"
  admin_username      = "ubuntu"
#   network_interface_ids = [ azurerm_network_interface.example.id]
  network_interface_ids = [var.network_id]

  admin_ssh_key {
    username   = "ubuntu"
    #public_key = file("~/.ssh/id_rsa.pub")  #Terraform's file() function does not expand ~ like a shell does
    # public_key = file("/root/.ssh/id_rsa.pub")
    public_key = var.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}