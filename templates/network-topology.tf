# Hub VNet

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.hub-rg.location
  resource_group_name = azurerm_resource_group.hub-rg.name
  address_space       = ["10.0.0.0/21"]
}

resource "azurerm_subnet" "hub-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "hub-azurefirewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.0.128/25"]
}

resource "azurerm_subnet" "hub-appgw_public-subnet" {
  name                 = "snet-appgw-public"
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "hub-appgw_private-subnet" {
  name                 = "snet-appgw-private"
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "hub-workload-subnet" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# App1 VNet

resource "azurerm_virtual_network" "app1-vnet" {
  name                = "app1-vnet"
  location            = azurerm_resource_group.app1-rg.location
  resource_group_name = azurerm_resource_group.app1-rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "app1-workload-subnet" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.app1-rg.name
  virtual_network_name = azurerm_virtual_network.app1-vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

# App2 VNet 

resource "azurerm_virtual_network" "app2-vnet" {
  name                = "app2-vnet"
  location            = azurerm_resource_group.app2-rg.location
  resource_group_name = azurerm_resource_group.app2-rg.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "app2-workload-subnet" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.app2-rg.name
  virtual_network_name = azurerm_virtual_network.app2-vnet.name
  address_prefixes     = ["10.2.0.0/16"]
}

# Peerings

resource "azurerm_virtual_network_peering" "hub-to-app1" {
  name                      = "hub-to-app1"
  resource_group_name       = azurerm_resource_group.hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app1-vnet.id
}

resource "azurerm_virtual_network_peering" "app1-to-hub" {
  name                      = "app1-to-hub"
  resource_group_name       = azurerm_resource_group.app1-rg.name
  virtual_network_name      = azurerm_virtual_network.app1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_virtual_network_peering" "hub-to-app2" {
  name                      = "hub-to-app2"
  resource_group_name       = azurerm_resource_group.hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app2-vnet.id
}

resource "azurerm_virtual_network_peering" "app2-to-hub" {
  name                      = "app2-to-hub"
  resource_group_name       = azurerm_resource_group.app2-rg.name
  virtual_network_name      = azurerm_virtual_network.app2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}