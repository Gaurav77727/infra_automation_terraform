data "azurerm_key_vault" "keyvault" {
  for_each = var.vms
  name                = each.value.keyvault_name
  resource_group_name = each.value.keyvault_rg
}

data "azurerm_key_vault_secret" "vm_username" {
  for_each    = var.vms
  name        = "vm-admin-username"
  key_vault_id = data.azurerm_key_vault.keyvault[each.key].id
}

data "azurerm_key_vault_secret" "vm_password" {
  for_each    = var.vms
  name        = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.keyvault[each.key].id
}

data "azurerm_subnet" "subnetfetch" {
  for_each = var.vms
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_network_interface" "nic" {
  for_each = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnetfetch[each.key].id
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
    admin_username = data.azurerm_key_vault_secret.vm_username[each.key].value
    admin_password = data.azurerm_key_vault_secret.vm_password[each.key].value
  }

  os_profile_linux_config {
    disable_password_authentication = false
 }
}

