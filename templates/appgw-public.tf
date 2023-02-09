resource "azurerm_public_ip" "hub-appgwpublic-pip" {
  name                = "AppGwPublic-pip"
  resource_group_name = azurerm_resource_group.hub-rg.name
  location            = azurerm_resource_group.hub-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "hub-appgwpublic" {
  name                = "AppGwPublic"
  resource_group_name = azurerm_resource_group.hub-rg.name
  location            = azurerm_resource_group.hub-rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "hub-appgw-public-subnet"
    subnet_id = azurerm_subnet.hub-appgw_public-subnet.id
  }

  frontend_port {
    name = "FrontEndPort_80"
    port = 80
  }

  frontend_port {
    name = "FrontEndPort_443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "AppGw-FrontEnd-Public"
    public_ip_address_id = azurerm_public_ip.hub-appgwpublic-pip.id
  }

  backend_address_pool {
    name         = "BackendPool-app1"
    ip_addresses = [azurerm_network_interface.app1-vm-nic.private_ip_address]
  }

  backend_address_pool {
    name         = "BackendPool-app2"
    ip_addresses = [azurerm_network_interface.app2-vm-nic.private_ip_address]
  }

  backend_http_settings {
    name                  = "BackendSetting_HTTP_80"
    cookie_based_affinity = "Disabled"
    //path                  = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "Listener-Public-Http_app1"
    frontend_ip_configuration_name = "AppGw-FrontEnd-Public"
    frontend_port_name             = "FrontEndPort_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    priority                   = 100
    name                       = "RoutingRule_app1"
    rule_type                  = "Basic"
    http_listener_name         = "Listener-Public-Http_app1"
    backend_address_pool_name  = "BackendPool-app1"
    backend_http_settings_name = "BackendSetting_HTTP_80"
  }
}

resource "azurerm_monitor_diagnostic_setting" "azure_applicationgateway_monitor" {
  name                       = "AzureApplicationGatewayMonitorLogs"
  target_resource_id         = azurerm_application_gateway.hub-appgwpublic.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azure_firewall_law.id

  enabled_log {
    category = "ApplicationGatewayFirewallLog"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ApplicationGatewayAccessLog"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"

    retention_policy {
      enabled = false
    }
  }
}