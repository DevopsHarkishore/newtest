resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string      
  
}
variable "resource_group_location" {
  description = "The location of the virtual network."
  type        = string
  default     = "West Europe"
  
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}   
variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}