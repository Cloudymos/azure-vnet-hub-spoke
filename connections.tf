resource "azurerm_virtual_network_gateway_connection" "conn_onpremises" {
  name                = "conn_onpremise"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id   = azurerm_local_network_gateway.lng_onpremises.id

  shared_key = "1234"

  depends_on = [azurerm_virtual_network_gateway.vng_onpremises]
}

resource "azurerm_virtual_network_gateway_connection" "conn_hub" {
  name                = "conn_hub"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng_onpremises.id
  local_network_gateway_id   = azurerm_local_network_gateway.lng_azure.id

  shared_key = "1234"

  depends_on = [azurerm_virtual_network_gateway.vng]
}