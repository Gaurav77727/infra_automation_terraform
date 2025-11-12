# Resource Group Variables

variable "rgs_parent" {
  type = map(object({
    rg_name    = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))

}

# Storage Account Variables

variable "stg_parents" {
  type = map(object(
    {
      name                              = string
      resource_group_name               = string
      location                          = string
      account_tier                      = string
      account_replication_type          = string
      access_tier                       = optional(string)
      account_kind                      = optional(string)
      provisioned_billing_model_version = optional(string)
      cross_tenant_replication_enabled  = optional(bool)
      edge_zone                         = optional(string)
      https_traffic_only_enabled        = optional(bool)
      min_tls_version                   = optional(string)
      allow_nested_items_to_be_public   = optional(bool)
      shared_access_key_enabled         = optional(bool)
      public_network_access_enabled     = optional(bool)
      default_to_oauth_authentication   = optional(bool)
      is_hns_enabled                    = optional(bool)
      nfsv3_enabled                     = optional(bool)
      large_file_share_enabled          = optional(bool)
      local_user_enabled                = optional(bool)
      queue_encryption_key_type         = optional(string)
      table_encryption_key_type         = optional(string)
      infrastructure_encryption_enabled = optional(bool)
      sftp_enabled                      = optional(bool)
      dns_endpoint_type                 = optional(string)
      allowed_copy_scope                = optional(string)
      tags                              = optional(map(string))
    }
  ))
}

# Key Vault Variables
variable "keyvault_parents" {
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    enabled_for_disk_encryption = bool
    soft_delete_retention_days  = number
    purge_protection_enabled    = bool
    sku_name                    = string
    tags                        = optional(map(string))
  }))
}

# Public IP Variables

variable "public_ip_parent" {
  type = map(object({
    name                    = string
    resource_group_name     = string
    location                = string
    allocation_method       = string
    sku                     = optional(string)
    ip_version              = optional(string)
    idle_timeout_in_minutes = optional(number)
    domain_name_label       = optional(string)
    zones                   = optional(list(string))
    tags                    = optional(map(string))
  }))
}

# Virtual Network Variables

variable "vnet_parents" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    subnets             = map(list(string)) # e.g. { frontend = ["10.0.1.0/24"], backend = ["10.0.2.0/24"] }
    tags                = optional(map(string))
  }))
}

# Virtual Machine Variables


variable "vm_parents" {
  type = map(object({
    nic_name    = string
    location    = string
    subnet_name = string
    vnet_name   = string
    rg_name     = string
    pip_name    = optional(string)

    keyvaultname            = string
    keyvaultrg_name         = string
    vm_username_secret_name = string
    vm_password_secret_name = string

    vm_name = string
    vm_size = string

    storage_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    storage_os_disk = object({
      name              = string
      caching           = string
      create_option     = string
      managed_disk_type = string
    })

    os_profile = object({
      computer_name  = string
      admin_username = string
      admin_password = string
    })

    os_profile_linux_config = object({
      disable_password_authentication = bool
    })

    tags = optional(map(string))
  }))
}