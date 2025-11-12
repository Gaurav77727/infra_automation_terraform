output "keyvault_id" {
  value = { for k, v in azurerm_key_vault.keyvault : k => v.id }
}

output "keyvault_name" {
  value = { for k, v in azurerm_key_vault.keyvault : k => v.name }
}

output "keyvault_rg" {
  value = { for k, v in var.keyvaults : k => v.resource_group_name }
}