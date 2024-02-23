resource "azurerm_local_network_gateway" "lng_onpremises" {
  name                = "lng-onpremises"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  gateway_address     = azurerm_public_ip.gateway_onpremises_ip.ip_address
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_local_network_gateway" "lng_azure" {
  name                = "lng-azure"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  gateway_address     = azurerm_public_ip.gateway_ip.ip_address
  address_space       = ["10.0.0.0/8"]
}