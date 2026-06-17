output nat_public_ip_UAT {
  value       = azurerm_public_ip.main.id
  description = "Public IP resource ID"
}
