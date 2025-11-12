data "azurerm_subnet" "bastion_subnet" {
  for_each = var.bastion_hosts
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group
}

data "azurerm_public_ip" "bastion_pip" {
  for_each = var.bastion_hosts
  name                = each.value.public_ip_name
  resource_group_name = each.value.public_ip_resource_group
}

resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bastion_hosts
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "bastionConfig"
    subnet_id            = data.azurerm_subnet.bastion_subnet[each.key].id
    public_ip_address_id = data.azurerm_public_ip.bastion_pip[each.key].id
  }
}