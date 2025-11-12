resource "azurerm_network_security_group" "nsg" {
  for_each = var.vnet
  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
    name                      = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
  }
}
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = {
    for vnet_name, vnet_data in var.vnet :
    "${vnet_name}-${vnet_data.nsg_name}" => {
      vnet_name   = vnet_name
      subnets     = vnet_data.subnet
      rg_name     = vnet_data.resource_group_name
    }
  }

  subnet_id = element([
    for s_name, s_data in azurerm_virtual_network.Virtual_Network[each.value.vnet_name].subnet :
    s_data.id
  ], 0)

  network_security_group_id = azurerm_network_security_group.nsg[each.value.vnet_name].id
}


resource "azurerm_virtual_network" "Virtual_Network" {
 for_each = var.vnet
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

  dynamic "subnet" {
    for_each = each.value.subnet
    content {
      name = subnet.key
      address_prefixes = subnet.value
    }
 }
}

