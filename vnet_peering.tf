# Creation of peerings from Hub to Spokes
resource "azurerm_virtual_network_peering" "hub_to_spokes" {
  count                     = length(var.spokes)
  name                      = "hub_to_${var.spokes[count.index].name}"
  resource_group_name       = azurerm_resource_group.rg_er.name
  virtual_network_name      = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id = azurerm_virtual_network.spokes_vnets[count.index].id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true

  depends_on = [azurerm_virtual_network_gateway.vng]
}

# Creation of peerings from Spokes to Hub
resource "azurerm_virtual_network_peering" "spokes_to_hub" {
  count                     = length(var.spokes)
  name                      = "${var.spokes[count.index].name}_to_hub"
  resource_group_name       = azurerm_resource_group.rg_er.name
  virtual_network_name      = azurerm_virtual_network.spokes_vnets[count.index].name
  remote_virtual_network_id = azurerm_virtual_network.vnet_hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true

  depends_on = [
    azurerm_virtual_network_gateway.vng,
    azurerm_virtual_network_peering.hub_to_spokes
    ]
}
