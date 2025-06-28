module "resource_group" {
  source = "../../Module/azurerm_resource_group"

  resource_group_name     = "rg-dev"
  resource_group_location = "West Europe"

}

module "virtual_network" {
  depends_on              = [module.resource_group]
  source                  = "../../Module/azurerm_virtual_network"
  resource_group_name     = "rg-dev"
  resource_group_location = "West Europe"
  virtual_network_name    = "vnet-dev"
  address_space           = ["10.0.0.0/16"]

}

module "frontend_nsg" {
  depends_on = [module.resource_group]
  source     = "../../Module/azurerm_network_security_group"

  resource_group_name     = "rg-dev"
  nsg_name                = "nsg-dev-frontend"
  resource_group_location = "West Europe"

}

module "backend_nsg" {
  depends_on = [module.resource_group]
  source     = "../../Module/azurerm_network_security_group"

  resource_group_name     = "rg-dev"
  nsg_name                = "nsg-dev-backend"
  resource_group_location = "West Europe"

}


module "frontend_subnet" {
  depends_on           = [module.virtual_network, module.frontend_nsg]
  source               = "../../Module/azurerm_subnet"
  resource_group_name  = "rg-dev"
  virtual_network_name = "vnet-dev"
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  nsg_name             = "nsg-dev-frontend"
}

module "backend_subnet" {
  depends_on           = [module.virtual_network, module.backend_nsg]
  source               = "../../Module/azurerm_subnet"
  resource_group_name  = "rg-dev"
  virtual_network_name = "vnet-dev"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.2.0/24"]
  nsg_name             = "nsg-dev-backend"
}

module "frontend_public_ip" {
  depends_on              = [module.frontend_subnet]
  source                  = "../../Module/azurerm_public_ip"
  public_ip_name          = "pip-dev-frontend"
  resource_group_name     = "rg-dev"
  resource_group_location = "West Europe"

}
module "backend_public_ip" {
  depends_on              = [module.backend_subnet]
  source                  = "../../Module/azurerm_public_ip"
  public_ip_name          = "pip-dev-backend"
  resource_group_name     = "rg-dev"
  resource_group_location = "West Europe"

}

module "key_vault" {
  depends_on              = [module.resource_group]
  source                  = "../../Module/azurerm_key_vault"
  key_vault_name          = "kv4480-dev"
  resource_group_name     = "rg-dev"
  resource_group_location = "West Europe"

}

module "key_vault_secret" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = "kv4480-dev"
  resource_group_name = "rg-dev"
  secret_name         = "secret-dev"
  secret_value        = "secret-value"
}

module "frontend_vm" {
  depends_on              = [module.frontend_subnet, module.frontend_public_ip, module.key_vault_secret, module.key_vault, module.resource_group, module.vm_username, module.vm_password]
  source                  = "../../Module/azurerm_linux_virtual_machine"
  virtual_machine_name    = "vm-dev-frontend"
  resource_group_name     = "rg-dev"
  virtual_network_name    = "vnet-dev"
  subnet_name             = "frontend-subnet"
  public_ip_name          = "pip-dev-frontend"
  resource_group_location = "West Europe"
  network_interface_name  = "nic-dev-frontend"
  virtual_machine_size    = "Standard_B1s"
  username_secret_name    = "vm-username"
  password_secret_name    = "vm-password"
  key_vault_name          = "kv4480-dev"

}
module "backend_vm" {
  depends_on              = [module.backend_subnet, module.backend_public_ip, module.key_vault_secret, module.key_vault, module.vm_username, module.vm_password, module.resource_group]
  source                  = "../../Module/azurerm_linux_virtual_machine"
  resource_group_name     = "rg-dev"
  virtual_machine_name    = "vm-dev-backend"
  virtual_network_name    = "vnet-dev"
  subnet_name             = "backend-subnet"
  public_ip_name          = "pip-dev-backend"
  virtual_machine_size    = "Standard_B1s"
  network_interface_name  = "nic-dev-backend"
  resource_group_location = "West Europe"
  username_secret_name    = "vm-username"
  password_secret_name    = "vm-password"
  key_vault_name          = "kv4480-dev"


}
module "mssql_server" {
  depends_on              = [module.resource_group, module.key_vault_secret, module.key_vault, module.sqlserver_username, module.sqlserver_password]
  source                  = "../../Module/azurerm_mssql_server"
  resource_group_name     = "rg-dev"
  mssqlserver_name        = "sqlserverdev121"
  resource_group_location = "centralus"
  username_secret_name    = "sqlserver-username"
  password_secret_name    = "sqlserver-password"
  key_vault_name          = "kv4480-dev"

}

module "mssql_database" {
  depends_on          = [module.mssql_server]
  source              = "../../Module/azurerm_mssql_database"
  resource_group_name = "rg-dev"
  server_name         = "sqlserverdev121"
  database_name       = "sqldev4480"

}

module "vm_username" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = "kv4480-dev"
  resource_group_name = "rg-dev"
  secret_name         = "vm-username"
  secret_value        = "adminuser"

}
module "vm_password" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = "kv4480-dev"
  resource_group_name = "rg-dev"
  secret_name         = "vm-password"
  secret_value        = "P@ssw0rd1234!"

}

module "sqlserver_username" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = "kv4480-dev"
  resource_group_name = "rg-dev"
  secret_name         = "sqlserver-username"
  secret_value        = "sqladmin"

}

module "sqlserver_password" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = "kv4480-dev"
  resource_group_name = "rg-dev"
  secret_name         = "sqlserver-password"
  secret_value        = "P@ssw0rd1234!"

}
