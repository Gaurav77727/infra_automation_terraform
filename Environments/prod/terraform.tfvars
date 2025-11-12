rgs_parent = {
  rgs = {
    rg_name    = "simplergprod701"
    location   = "Central India"
    managed_by = "gaurav-ji"
    tags = {
      Environments = "prod"
      Owner        = "gaurav"
    }
  }
}

stg_parents = {
  stg1 = {
    name                     = "rgstorageatozprod"
    resource_group_name      = "simplergprod701"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      environment = "prod"
    }
  }
}

keyvault_parents = {

  keyvault1 = {
    name                        = "Dhankeyvaultprod77"
    location                    = "Central India"
    resource_group_name         = "simplergprod701"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
  }
}

public_ip_parent = {
  pip1 = {
    name                = "pipprodvm1"
    resource_group_name = "simplergprod701"
    location            = "Central India"
    allocation_method   = "Static"

    tags = {
      environment = "prod"
    }

  }

}

vnet_parents = {
  vnet1 = {
    name                = "dev-vnetprod"
    location            = "Central India"
    resource_group_name = "simplergprod701"
    address_space       = ["10.0.0.0/16"]

    subnets = {
      frontendsubnetprod1 = ["10.0.1.0/24"]
      backendsubnetprod2  = ["10.0.2.0/24"]
    }
  }
}


vm_parents = {
  vm1 = {
    nic_name    = "nic1prod"
    location    = "Central India"
    subnet_name = "frontendsubnetprod1"
    vnet_name   = "dev-vnet"
    rg_name     = "simplergprod701"
    # pip_name     = "pipprodvm1"
    keyvaultname            = "riyatigoriprod"
    keyvaultrg_name         = "riya-rg"
    vm_username_secret_name = "adminusername"
    vm_password_secret_name = "adminpassword"
    vm_name                 = "vm1"
    vm_size                 = "Standard_B2s"
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    storage_os_disk = {
      name              = "storagedisk1"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile = {
      computer_name  = "hostname"
      admin_username = "adminuser"
      admin_password = "Password@123"

    }
    os_profile_linux_config = {
      disable_password_authentication = false
    }

  }
}
