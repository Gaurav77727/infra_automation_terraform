rgs_parent = {
  rgs = {
    rg_name    = "simplerg701"
    location   = "Central India"
    managed_by = "gaurav-ji"
    tags = {
      Environments = "Dev"
      Owner        = "gaurav"
    }
  }
}

stg_parents = {
  stg1 = {
    name                     = "rgstorageatoz"
    resource_group_name      = "simplerg701"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      environment = "Dev"
    }
  }
}

keyvault_parents = {

  keyvault1 = {
    name                        = "Dhankeyvault77"
    location                    = "Central India"
    resource_group_name         = "simplerg701"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
  }
}

# --- Public IPs: added entries for LB and Bastion lookups ---
public_ip_parent = {
  pip1 = {
    name                = "pipvm1"
    resource_group_name = "simplerg701"
    location            = "Central India"
    allocation_method   = "Static"

    tags = {
      environment = "Production"
    }
  }

  app_lb_pip = {
    name                = "app-lb-pip"
    resource_group_name = "simplerg701"
    location            = "Central India"
    allocation_method   = "Static"
  }

  internal_lb_pip = {
    name                = "internal-lb-pip"
    resource_group_name = "simplerg701"
    location            = "Central India"
    allocation_method   = "Static"
  }

  bastion_pip = {
    name                = "bastion-pip"
    resource_group_name = "simplerg701"
    location            = "Central India"
    allocation_method   = "Static"
  }
}

vnet_parents = {
  vnet1 = {
    nsg_name            = "nsg1"
    name                = "dev-vnet"
    location            = "Central India"
    resource_group_name = "simplerg701"
    address_space       = ["10.0.0.0/16"]

    subnet = {
      frontendsubnet1    = ["10.0.1.0/24"]
      backendsubnet2     = ["10.0.2.0/24"]
      AzureBastionSubnet = ["10.0.3.0/27"] # added for Bastion Host requirement
    }

    security_rules = [
      {
        name                       = "allow-ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow-http"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

vms = {
  vm1 = {
    rg_name       = "simplerg701"
    location      = "Central India"
    vnet_name     = "dev-vnet"
    subnet_name   = "frontendsubnet1"
    nic_name      = "nic1"
    vm_name       = "frontenedvm"
    vm_size       = "Standard_B1s"
    keyvault_name = "Dhankeyvault77"
    keyvault_rg   = "simplerg701"
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    storage_os_disk = {
      name              = "demo-osdisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    os_profile = {
      computer_name = "demo-vm"
    }
  }
}

aks_clusters = {
  aks1 = {
    name                = "aks-cluster"
    location            = "Central India"
    resource_group_name = "simplerg701"
    dns_prefix          = "exampleaks1"

    default_node_pool = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_D2_v2"
    }

    identity = {
      type = "SystemAssigned"
    }

    tags = {
      Environment = "Production"
    }
  }
}

acrs = {
  acr1 = {
    name                = "simpledevacr01"
    resource_group_name = "simplerg701"
    location            = "Central India"
    sku                 = "Premium"
    admin_enabled       = false
    georeplications = {
      eastus = {
        location                = "East US" # fixed region
        zone_redundancy_enabled = true
        tags                    = {}
      }
      northeurope = {
        location                = "North Europe"
        zone_redundancy_enabled = true
        tags                    = {}
      }
    }
  }
}

sql_servers = {
  sql_servers1 = {
    name                         = "mssqlserver"
    resource_group_name          = "simplerg701"
    location                     = "Central India"
    version                      = "12.0"
    administrator_login          = "mradministrator"
    administrator_login_password = "thisIsDog11"

    tags = {
      environment = "production"
    }
  }
}

# --- DB needs to reference the SQL server so module knows where to create DBs ---
mssql_databases = {
  dev = {
    name                = "dev-db"
    max_size_gb         = 2
    sku_name            = "S0"
    env                 = "dev"
    sql_server_name     = "mssqlserver" # added
    resource_group_name = "simplerg701" # added
  }
}

load_balancers = {
  app_lb = {
    name                = "app-loadbalancer"
    location            = "Central India"
    resource_group_name = "simplerg701"

    # Public IP (use data lookup or resource) — matching public_ip_parent entries above
    public_ip_name           = "app-lb-pip"
    public_ip_resource_group = "simplerg701"

    frontend_ip_configuration = {
      name = "app-frontend"
    }

    backend_address_pool = {
      name = "app-backend-pool"
    }

    lb_probe = {
      name = "app-probe"
      port = 80
    }

    lb_rule = {
      name          = "app-http-rule"
      protocol      = "Tcp"
      frontend_port = 80
      backend_port  = 80
    }
  }

  internal_lb = {
    name                = "internal-lb"
    location            = "Central India"
    resource_group_name = "simplerg701"

    public_ip_name           = "internal-lb-pip"
    public_ip_resource_group = "simplerg701"

    frontend_ip_configuration = {
      name = "internal-frontend"
    }

    backend_address_pool = {
      name = "internal-backend-pool"
    }

    lb_probe = {
      name = "internal-probe"
      port = 443
    }

    lb_rule = {
      name          = "internal-https-rule"
      protocol      = "Tcp"
      frontend_port = 443
      backend_port  = 443
    }
  }
}

bastion_hosts = {
  bastion1 = {
    name                = "bastion-host-1"
    location            = "Central India"
    resource_group_name = "simplerg701"

    subnet_name         = "AzureBastionSubnet"
    vnet_name           = "dev-vnet" # aligned with vnet_parents
    vnet_resource_group = "simplerg701"

    public_ip_name           = "bastion-pip"
    public_ip_resource_group = "simplerg701"
  }
}
