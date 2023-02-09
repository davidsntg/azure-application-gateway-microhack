provider "azurerm" {
  features {}

}

# Resource Groups

resource "azurerm_resource_group" "hub-rg" {
  name     = "hub-rg"
  location = var.azure_location
}

resource "azurerm_resource_group" "app1-rg" {
  name     = "app1-rg"
  location = var.azure_location
}

resource "azurerm_resource_group" "app2-rg" {
  name     = "app2-rg"
  location = var.azure_location
}