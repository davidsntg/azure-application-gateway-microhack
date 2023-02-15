# Hub VM

resource "azurerm_network_interface" "hub-vm-nic" {
  name                = "hub-vmni01"
  location            = azurerm_resource_group.hub-rg.location
  resource_group_name = azurerm_resource_group.hub-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.hub-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "hub-vm" {
  name                            = "hub-vm"
  location                        = azurerm_resource_group.hub-rg.location
  resource_group_name             = azurerm_resource_group.hub-rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = "false"
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.hub-vm-nic.id]
  custom_data                     = base64encode(local.apache2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "hub-vmod01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
  
  boot_diagnostics {
    
  }
}


# App1 VM

resource "azurerm_network_interface" "app1-vm-nic" {
  name                = "app1-vmni01"
  location            = azurerm_resource_group.app1-rg.location
  resource_group_name = azurerm_resource_group.app1-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.app1-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app1-vm" {
  name                            = "app1-vm"
  location                        = azurerm_resource_group.app1-rg.location
  resource_group_name             = azurerm_resource_group.app1-rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = "false"
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.app1-vm-nic.id]
  custom_data                     = base64encode(local.apache2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "app1-vmod01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
  
  boot_diagnostics {
    
  }
}

# App2 VM

resource "azurerm_network_interface" "app2-vm-nic" {
  name                = "app2-vmni01"
  location            = azurerm_resource_group.app2-rg.location
  resource_group_name = azurerm_resource_group.app2-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.app2-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app2-vm" {
  name                            = "app2-vm"
  location                        = azurerm_resource_group.app2-rg.location
  resource_group_name             = azurerm_resource_group.app2-rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = "false"
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.app2-vm-nic.id]
  custom_data                     = base64encode(local.apache2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "app2-vmod01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
  
  boot_diagnostics {
    
  }
}
