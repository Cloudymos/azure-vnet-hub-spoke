resource "azurerm_virtual_network" "vnet_onpremises" {
  name                = "vnet-onpremises"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "snet_onpremises_gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_onpremises.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "snet_onpremises_servers" {
  name                 = "snet-servers"
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_onpremises.name
  address_prefixes     = ["172.16.1.0/24"]
}