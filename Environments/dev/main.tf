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

module "AKS_Cluster" {
  depends_on   = [module.Resource_group, module.Virtual_Network]
  source       = "../../modules/azurerm_aks"
  aks_clusters = var.aks_clusters
}

module "acr" {
  depends_on = [module.Resource_group]
  source     = "../../modules/azurerm_acr"
  acrs       = var.acrs
}

module "sql_server" {
  depends_on  = [module.Resource_group]
  source      = "../../modules/azurerm_mssql_server"
  sql_servers = var.sql_servers
}

module "azurerm_mssql_database" {
  depends_on      = [module.sql_server]
  source          = "../../modules/azurerm_mssql_database"
  server_id       = module.sql_server.sql_server_ids["sql_servers1"]
  mssql_databases = var.mssql_databases
}

module "azurerm_loadbalancer" {
  depends_on     = [module.Resource_group, module.Public_Ip]
  source         = "../../modules/azurerm_loadbalancer"
  load_balancers = var.load_balancers
}

module "bastion" {
  source        = "../../modules/azurerm_bastion"
  depends_on    = [module.Virtual_Network, module.Public_Ip]
  bastion_hosts = var.bastion_hosts
}