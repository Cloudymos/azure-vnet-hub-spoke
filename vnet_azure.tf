
#HUB
resource "azurerm_virtual_network" "vnet_hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  address_space       = var.hub_address_space
}

resource "azurerm_subnet" "snet_gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.gateway_snet_address_space
}

resource "azurerm_subnet" "snet_shared" {
  name                 = var.shared_snet_name
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.shared_snet_address_space
}

resource "azurerm_subnet" "snet_firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.firewall_snet_address_space
}

resource "azurerm_subnet" "snet_routeserversubnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.routeserver_snet_address_space
}

resource "azurerm_virtual_network" "spokes_vnets" {
  count               = length(var.spokes)
  name                = var.spokes[count.index].name
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  address_space       = [var.spokes[count.index].address_space]
}

resource "azurerm_subnet" "spokes_subnets" {
  count               = length(flatten([for spoke in var.spokes : spoke.subnets]))
  name                = var.spokes[count.index % length(var.spokes)].subnets[count.index % length(var.spokes[count.index % length(var.spokes)].subnets)].name
  resource_group_name = azurerm_resource_group.rg_er.name
  virtual_network_name = azurerm_virtual_network.spokes_vnets[count.index % length(var.spokes)].name
  address_prefixes     = var.spokes[count.index % length(var.spokes)].subnets[count.index % length(var.spokes[count.index % length(var.spokes)].subnets)].address_prefixes
}

