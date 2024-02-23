#subnets
output "snet_firewallsubnet_id" {
  value = azurerm_subnet.snet_firewallsubnet.id
}

output "snet_gatewaysubnet_id" {
  value = azurerm_subnet.snet_gatewaysubnet.id
}

output "snet_onpremises_gatewaysubnet_id" {
  value = azurerm_subnet.snet_onpremises_gatewaysubnet.id
}

output "snet_shared_id" {
  value = azurerm_subnet.snet_shared.id
}

# Outputs of the names of spoke subnets
output "spokes_subnets_names" {
  value = [for subnet in azurerm_subnet.spokes_subnets : subnet.name]
}

# Outputs of the IDs of spoke subnets
output "spokes_subnets_ids" {
  value = [for subnet in azurerm_subnet.spokes_subnets : subnet.id]
}

# Outputs of the address prefixes of spoke subnets
output "spokes_subnets_address_prefixes" {
  value = [for subnet in azurerm_subnet.spokes_subnets : subnet.address_prefixes]
}

#VNets
# Outputs of the names of spoke VNets
output "spokes_vnets_names" {
  value = [for vnet in azurerm_virtual_network.spokes_vnets : vnet.name]
}

# Outputs of the IDs of spoke VNets
output "spokes_vnets_ids" {
  value = [for vnet in azurerm_virtual_network.spokes_vnets : vnet.id]
}

# Outputs of the address spaces of spoke VNets
output "spokes_vnets_address_spaces" {
  value = [for vnet in azurerm_virtual_network.spokes_vnets : vnet.address_space]
}

output "vnet_hub_id" {
  value = azurerm_virtual_network.vnet_hub.id
}

output "vnet_hub_name" {
  value = azurerm_virtual_network.vnet_hub.name
}

#Route Table
output "route_table_default_id" {
  value = azurerm_route_table.route_table_default.id
}

output "route_table_gateway_id" {
  value = azurerm_route_table.route_table_gateway.id
}

#RG
output "rg_location" {
  value = azurerm_resource_group.rg_er.location
}

output "rg_name" {
  value = azurerm_resource_group.rg_er.name
}

#public ips
output "gateway_ip_ip_address" {
  value = azurerm_public_ip.gateway_ip.ip_address
}

output "gateway_ip_gateway_onpremises_ip" {
  value = azurerm_public_ip.gateway_onpremises_ip.ip_address
}