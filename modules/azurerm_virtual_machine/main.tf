# data "azurerm_key_vault" "keyvaultfetch" {
#   for_each = var.vms
#   name                = each.value.keyvaultname
#   resource_group_name = each.value.keyvaultrg_name
# }

# # Fetch secrets from Key Vault
# data "azurerm_key_vault_secret" "vm_username" {
#   for_each    = var.vms
#   name        = each.value.vm_username_secret_name
#   key_vault_id = data.azurerm_key_vault.keyvaultfetch[each.key].id
# }

# data "azurerm_key_vault_secret" "vm_password" {
#   for_each    = var.vms
#   name        = each.value.vm_password_secret_name
#   key_vault_id = data.azurerm_key_vault.keyvaultfetch[each.key].id
# }

data "azurerm_subnet" "subnetfetch" {
  for_each = var.vms
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

# data "azurerm_public_ip" "pipfetch" {
#   for_each = var.vms
#   name                = each.value.pip_name
#   resource_group_name = each.value.rg_name
# }

resource "azurerm_network_interface" "nic" {
  for_each = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnetfetch[each.key].id
    # public_ip_address_id          = data.azurerm_public_ip.pipfetch[each.key].id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_virtual_machine" "vm" {
  for_each = var.vms
  name                  = each.value.vm_name
  resource_group_name   = each.value.rg_name
  location              = each.value.location
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size               = each.value.vm_size

  storage_image_reference {
    publisher = each.value.storage_image_reference.publisher
    offer     = each.value.storage_image_reference.offer
    sku       = each.value.storage_image_reference.sku
    version   = each.value.storage_image_reference.version
  }

  storage_os_disk {
    name              = each.value.storage_os_disk.name
    caching           = each.value.storage_os_disk.caching
    create_option     = each.value.storage_os_disk.create_option
    managed_disk_type = each.value.storage_os_disk.managed_disk_type
  }

  os_profile {
    computer_name  = each.value.os_profile.computer_name
    admin_username = each.value.os_profile.admin_username
    admin_password = each.value.os_profile.admin_password
  }
  #Required for Linux VM
  os_profile_linux_config {
    disable_password_authentication = false
 }
}