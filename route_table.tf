resource "azurerm_route_table" "route_table_default" {
  name                          = "rt-default"
  location                      = azurerm_resource_group.rg_er.location
  resource_group_name           = azurerm_resource_group.rg_er.name
  disable_bgp_route_propagation = true

  route {
    name                   = "rt-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost(azurerm_subnet.snet_firewallsubnet.address_prefixes[0], 4)
  }
}

# Definition of the route table
resource "azurerm_route_table" "route_table_gateway" {
  name                = "rt-gateway"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name

  # Route for the shared subnet
  route {
    name                   = "rt-shared"
    address_prefix         = azurerm_subnet.snet_shared.address_prefixes[0]
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost(azurerm_subnet.snet_firewallsubnet.address_prefixes[0], 4)
  }

  # Route for each spoke
  dynamic "route" {
    for_each = var.spokes

    content {
      name                   = "rt-${route.value.name}"
      address_prefix         = route.value.address_space
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = cidrhost(azurerm_subnet.snet_firewallsubnet.address_prefixes[0], 4)
    }
  }
}


resource "azurerm_subnet_route_table_association" "route_table_default_association_vnet_hub_snet_shared" {
  subnet_id      = azurerm_subnet.snet_shared.id
  route_table_id = azurerm_route_table.route_table_default.id

  depends_on = [azurerm_virtual_network.vnet_hub, azurerm_subnet.snet_shared, azurerm_route_table.route_table_default, azurerm_virtual_network_gateway.vng]
}

resource "azurerm_subnet_route_table_association" "route_table_spokes_associations" {
  count          = length(var.spokes)
  subnet_id      = azurerm_subnet.spokes_subnets[count.index].id
  route_table_id = azurerm_route_table.route_table_default.id

  depends_on = [
    # azurerm_virtual_network.spokes_vnets[count.index],
    # azurerm_subnet.spokes_subnets[count.index],
    azurerm_route_table.route_table_default,
    azurerm_virtual_network_gateway.vng
  ]
}

resource "azurerm_subnet_route_table_association" "route_table_gateway_association_vnet_hub_snet_gatewaysubnet" {
  subnet_id      = azurerm_subnet.snet_gatewaysubnet.id
  route_table_id = azurerm_route_table.route_table_gateway.id

  depends_on = [azurerm_virtual_network.vnet_hub, azurerm_subnet.snet_gatewaysubnet, azurerm_route_table.route_table_gateway, azurerm_virtual_network_gateway.vng]
}