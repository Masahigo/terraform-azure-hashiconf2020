output "siteUrl" {
  value = azurerm_app_service.main.default_site_hostname
}

output "mongoDbHost" {
  value = azurerm_container_group.main.fqdn
}

output "sqlServerFqdn" {
    value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}