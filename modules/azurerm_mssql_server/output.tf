output "sql_server_ids" {
  description = "Map of SQL Server IDs"
  value = {
    for k, v in azurerm_mssql_server.sql : k => v.id
  }
}
