resource "azurerm_subnet" "subnet_name"{
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_name.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

data "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}
variable "address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

variable "nsg_name" {
  description = "The name of the network security group to associate with the subnet."
  type        = string
}