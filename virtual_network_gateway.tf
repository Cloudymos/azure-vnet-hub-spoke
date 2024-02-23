#VPN Gateway
resource "azurerm_public_ip" "gateway_ip" {
  name                = "gateway_ip"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                = "VPN-HUB"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gateway_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet_gatewaysubnet.id
  }

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  depends_on = [azurerm_subnet.snet_firewallsubnet,
    azurerm_subnet.snet_gatewaysubnet,
    azurerm_subnet.snet_routeserversubnet,
  azurerm_subnet.snet_shared]
}

#VPN Onpremises
resource "azurerm_public_ip" "gateway_onpremises_ip" {
  name                = "gateway_onpremises_ip"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vng_onpremises" {
  name                = "VPN-Onpremises"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gateway_onpremises_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet_onpremises_gatewaysubnet.id
  }

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }
}