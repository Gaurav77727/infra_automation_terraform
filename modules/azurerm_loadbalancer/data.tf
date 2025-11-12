data "azurerm_public_ip" "pip" {
    for_each = var.load_balancers
    name                = each.value.public_ip_name
    resource_group_name = each.value.public_ip_resource_group
}