data "azurerm_client_config" "keyvaultconfig" {}

resource "azurerm_key_vault" "keyvault" {
  for_each = var.keyvaults
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.keyvaultconfig.tenant_id
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled    = each.value.purge_protection_enabled

  sku_name = each.value.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.keyvaultconfig.tenant_id
    object_id = data.azurerm_client_config.keyvaultconfig.object_id

    key_permissions     = ["Get", "List", "Create", "Delete"]
    secret_permissions  = ["Get", "List", "Set", "Delete"]
  }
}



# Secret creation for VM credentials
resource "random_password" "vm_password" {
  for_each = var.keyvaults
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "vm_username" {
  for_each    = var.keyvaults
  name        = "vm-admin-username"
  value       = "azureadmin" # ya variable se pass kar
  key_vault_id = azurerm_key_vault.keyvault[each.key].id
}

resource "azurerm_key_vault_secret" "vm_password" {
  for_each    = var.keyvaults
  name        = "vm-admin-password"
  value       = random_password.vm_password[each.key].result
  key_vault_id = azurerm_key_vault.keyvault[each.key].id
}


