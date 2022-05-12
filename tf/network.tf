terraform {
  backend "azurerm" {
    resource_group_name  = "tflint"
    storage_account_name = "tfmgrabarz"
    container_name       = "tfstatedevops"
    key                  = "tfstatedevops.tfstate"
  }
}

provider "azurerm" {
  version = "=2.0.0"
  features {}
}

module "naming" {
  source = "Azure/naming/azurerm"
  prefix = ["bank"]
  suffix = [var.solution_stage, var.solution_name]
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = "West Europe"
}
resource "azurerm_virtual_network" "vnet1" {
  name                = module.naming.virtual_network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.10.0.0/24"]
}
resource "azurerm_subnet" "app-subnet" {
  name                 = module.naming.subnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefix       = "10.10.0.0/25"
}
