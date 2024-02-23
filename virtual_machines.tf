#Hub
resource "azurerm_network_interface" "vm_hub_shared_nic" {
  count               = var.create_vms ? 1 : 0

  name                = "vm_hub_nic"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_shared.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_virtual_network_gateway.vng]
}

resource "azurerm_linux_virtual_machine" "vm_hub_shared" {
  count                           = var.create_vms ? 1 : 0

  name                            = "VM-HUB-SHARED"
  location                        = azurerm_resource_group.rg_er.location
  resource_group_name             = azurerm_resource_group.rg_er.name
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_hub_shared_nic[count.index].id,
  ]
  encryption_at_host_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [azurerm_virtual_network_gateway.vng]
}

#Onpremises
resource "azurerm_network_interface" "vm_onpremises_nic" {
  count               = var.create_vms ? 1 : 0

  name                = "vm_onpremises_nic"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet_onpremises_servers.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_virtual_network_gateway.vng_onpremises]
}

resource "azurerm_linux_virtual_machine" "vm_onpremises" {
  count                           = var.create_vms ? 1 : 0

  name                            = "VM-ONPREMISES"
  location                        = azurerm_resource_group.rg_er.location
  resource_group_name             = azurerm_resource_group.rg_er.name
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_onpremises_nic[count.index].id,
  ]
  encryption_at_host_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [azurerm_virtual_network_gateway.vng_onpremises]
}

# VMs spokes
resource "azurerm_network_interface" "vm_spokes_nics" {
  count               = var.create_vms ? length(var.spokes) : 0
  name                = "vm_${var.spokes[count.index].name}_snet_servers_nic"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spokes_subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet.spokes_subnets]
}

resource "azurerm_linux_virtual_machine" "vm_spokes" {
  count                         = var.create_vms ? length(var.spokes) : 0
  name                          = "VM-${var.spokes[count.index].name}"
  location                      = azurerm_resource_group.rg_er.location
  resource_group_name           = azurerm_resource_group.rg_er.name
  size                          = "Standard_B1s"
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  disable_password_authentication = false
  network_interface_ids         = [azurerm_network_interface.vm_spokes_nics[count.index].id]
  encryption_at_host_enabled    = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.vm_spokes_nics]
}