output vm_public_ip {
  value       = azurerm_public_ip.main.id
  description = "Public ip_address"
}
