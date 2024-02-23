# Public IP address
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_virtual_network.vnet_hub
  ]
}

resource "azurerm_firewall" "firewall_hub" {
  name                = "firewall-hub"
  location            = azurerm_resource_group.rg_er.location
  resource_group_name = azurerm_resource_group.rg_er.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  depends_on = [
    azurerm_virtual_network.vnet_hub,
    azurerm_firewall_policy.firewall_policy
  ]
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.rg_er.name
  location            = azurerm_resource_group.rg_er.location

  depends_on = [
    azurerm_virtual_network.vnet_hub
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rule" {
  name               = "fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 500

  network_rule_collection {
    name     = "Allow_All"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "Allow_All"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "VMs"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.firewall_public_ip.ip_address
      destination_ports   = ["22"]
      translated_address  = "10.0.1.4" #azurerm_network_interface.vm_hub_shared_nic.ip_configuration.private_ip_address_allocation
      translated_port     = "22"
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet_hub,
    azurerm_firewall.firewall_hub
  ]
}