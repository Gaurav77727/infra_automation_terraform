module "Resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs_parent
}

module "storage_account" {
  depends_on    = [module.Resource_group]
  source        = "../../modules/azurerm_storage_account"
  stg_arguments = var.stg_parents
}

module "Key_Vault" {
  depends_on = [module.Resource_group]
  source     = "../../modules/azurerm_keyvault"
  keyvaults  = var.keyvault_parents

}

module "Public_Ip" {
  depends_on = [module.Resource_group]
  source     = "../../modules/azurerm_public_ip"
  public_ip  = var.public_ip_parent

}

module "Virtual_Network" {
  depends_on = [module.Resource_group]
  source     = "../../modules/azurerm_virtual_network"
  vnet       = var.vnet_parents
}

module "VM" {
  depends_on = [module.Resource_group, module.Virtual_Network]
  source     = "../../modules/azurerm_virtual_machine"
  vms        = var.vm_parents
}

