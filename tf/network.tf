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
resource
"azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "West Europe"
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "terraform" {
  name = "terraform-network"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = ["10.10.0.0/24"]
}
resource "azurerm_subnet" "app-subnet" {
  name = "appsubnet01"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.terraform.name
  address_prefix = "10.10.0.0/25"
}
