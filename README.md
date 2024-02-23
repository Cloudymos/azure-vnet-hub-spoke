# azure-vpc-hub-spoke
This Terraform module provisions Azure network infrastructure, including virtual networks (VNets), subnets, route tables, network security groups, peering connections, and virtual machines (VMs), to establish a hub-and-spoke network topology. **For additional resources, examples, and community engagement**, check out the portal [Cloudymos](https://cloudymos.com) :cloud:.

## Features

- **Hub-and-Spoke Topology**: Creates a hub-and-spoke network architecture with a central hub VNet and multiple spoke VNets.
- **Customization**: Allows customization of VNet address spaces, subnet configurations, route tables, and VM configurations for each subnet.
- **VPN Connectivity**: Sets up VPN gateways and connections between on-premises networks and the Azure virtual network.
- **Firewall Configuration**: Deploys Azure Firewall for network security and traffic filtering.
- **Route Management**: Configures route tables for routing traffic between subnets and to on-premises networks.
- **Virtual Machines (Optional)**: Creates virtual machines for each spoke to enable workloads in each subnet. This feature is optional and can be used to validate the connection between spokes and the hub.
- **Resource Group**: Optionally allows you to specify the name and location of the Azure resource group.

## Usage

```hcl
module "azure_network_infrastructure" {
  source  = "organization/module/azure_network_infrastructure"
  version = "1.0.0"

  # Virtual Machine Configuration
  create_vms      = true
  admin_username  = "admin"
  admin_password  = "P@ssw0rd1234"
  
  # Spokes configuration
  spokes = [
    {
      name = "vnet-spoke-1"
      address_space = "10.1.0.0/16"
      subnets = [
        {
          name = "snet-spoke-1-servers"
          address_prefixes = ["10.1.1.0/24"]
        },
        {
          name = "snet-spoke-1-devices"
          address_prefixes = ["10.1.2.0/24"]
        }
      ]
    },
    {
      name = "vnet-spoke-2"
      address_space = "10.2.0.0/16"
      subnets = [
        {
          name = "snet-spoke-2-servers"
          address_prefixes = ["10.2.1.0/24"]
        }
      ]
    }
  ]

  # Resource group configuration
  rg_name     = "rg-er"
  rg_location = "East US"
}
```

## Inputs

| Name                          | Description                                                | Type          | Default       |
|-------------------------------|------------------------------------------------------------|---------------|---------------|
| hub_vnet_name                 | Name of the hub's virtual network                          | string        | "vnet-hub"    |
| hub_address_space             | Address space of the hub's virtual network                 | list(string)  | ["10.0.0.0/16"] |
| gateway_snet_address_space    | Address space of the gateway subnet                        | list(string)  | ["10.0.0.0/24"] |
| shared_snet_name              | Name of the hub's shared subnet                            | string        | "snet-shared" |
| shared_snet_address_space     | Address space of the shared subnet                         | list(string)  | ["10.0.1.0/24"] |
| firewall_snet_address_space   | Address space of the firewall subnet                       | list(string)  | ["10.0.2.0/24"] |
| routeserver_snet_address_space| Address space of the routeserver subnet                    | list(string)  | ["10.0.3.0/24"] |
| spokes                        | List of configurations for the spokes                      | list(object) | []            |
| vm_size                       | Size of the virtual machines                               | string        | "Standard_B1s" |
| admin_username                | Administrator username for the virtual machines            | string        | -              |
| admin_password                | Administrator password for the virtual machines            | string        | -              |
| rg_name                       | Name of the Azure resource group                           | string        | "rg-er"        |
| rg_location                   | Location (region) of the Azure resource group              | string        | "East US"      |
| create_vms                    | Flag to determine whether to create virtual machines or not | bool         | true           |
| admin_username                | Administrator username for the virtual machines            | string        | "usradmin"     |
| admin_password                | Administrator password for the virtual machines            | string        | "P@ssWord!!$4" |

## Outputs

| Name                               | Description                                  |
|------------------------------------|----------------------------------------------|
| snet_firewallsubnet_id             | ID of the firewall subnet                    |
| snet_gatewaysubnet_id              | ID of the gateway subnet                     |
| snet_onpremises_gatewaysubnet_id   | ID of the on-premises gateway subnet         |
| snet_shared_id                     | ID of the shared subnet                      |
| spokes_subnets_names               | Names of the spoke subnets                   |
| spokes_subnets_ids                 | IDs of the spoke subnets                     |
| spokes_subnets_address_prefixes    | Address prefixes of the spoke subnets        |
| spokes_vnets_names                 | Names of the spoke VNets                     |
| spokes_vnets_ids                   | IDs of the

 spoke VNets                       |
| spokes_vnets_address_spaces        | Address spaces of the spoke VNets            |
| vnet_hub_id                        | ID of the hub's virtual network              |
| vnet_hub_name                      | Name of the hub's virtual network            |
| route_table_default_id             | ID of the default route table                |
| route_table_gateway_id             | ID of the gateway route table                |
| rg_location                        | Location (region) of the Azure resource group|
| rg_name                            | Name of the Azure resource group             |
| gateway_ip_ip_address              | Public IP address of the VPN gateway         |
| gateway_ip_gateway_onpremises_ip  | Public IP address of the on-premises gateway|

