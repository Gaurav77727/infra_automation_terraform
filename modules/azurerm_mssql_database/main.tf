resource "azurerm_mssql_database" "mssql_database" {
  for_each     = var.mssql_databases
  name         = each.value.name
  server_id    = var.server_id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = each.value.max_size_gb
  sku_name     = each.value.sku_name
  enclave_type = "VBS"

  tags = {
    environment = each.value.env
  }

  lifecycle {
    prevent_destroy = true
  }
}

