output "siteUrl" {
  value = azurerm_app_service.main.default_site_hostname
}

output "mongoDbUrl" {
  value = azurerm_container_group.main.fqdn
}