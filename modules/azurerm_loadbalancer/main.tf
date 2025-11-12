resource "azurerm_lb" "lb" {
    for_each = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration.name
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
    for_each = var.load_balancers
  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = each.value.backend_address_pool.name
}

resource "azurerm_lb_rule" "lb_rule" {
    for_each = var.load_balancers
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  name                           = each.value.lb_rule.name
  protocol                       = each.value.lb_rule.protocol
  frontend_port                  = each.value.lb_rule.frontend_port
  backend_port                   = each.value.lb_rule.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool[each.key].id]
  probe_id                       = azurerm_lb_probe.lb_probe[each.key].id
}

resource "azurerm_lb_probe" "lb_probe" {
    for_each = var.load_balancers
  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = each.value.lb_probe.name
  port            = each.value.lb_probe.port
}