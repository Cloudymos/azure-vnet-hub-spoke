########################
#### VNET VARIABLES ####
########################

# variables.tf

variable "hub_vnet_name" {
  description = "Name of the hub's virtual network"
  type        = string
  default     = "vnet-hub"
}

variable "hub_address_space" {
  description = "Address space of the hub's virtual network"
  type        = list
  default     = ["10.0.0.0/16"]
}

variable "gateway_snet_address_space" {
  description = "Address space of the gateway subnet"
  type        = list
  default     = ["10.0.0.0/24"]
}

variable "shared_snet_name" {
  description = "Name of the hub's shared subnet"
  type        = string
  default     = "snet-shared"
}

variable "shared_snet_address_space" {
  description = "Address space of the shared subnet"
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "firewall_snet_address_space" {
  description = "Address space of the firewall subnet"
  type        = list
  default     = ["10.0.2.0/24"]
}

variable "routeserver_snet_address_space" {
  description = "Address space of the routeserver subnet"
  type        = list
  default     = ["10.0.3.0/24"]
}

variable "spokes" {
  description = "List of configurations for the spokes"
  type        = list(object({
    name           = string
    address_space  = string
    subnets        = list(object({
      name             = string
      address_prefixes = list(string)
    }))
  }))
}

##################################
#### RESOURCE GROUP VARIABLES ####
##################################

variable "rg_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-er"
}

variable "rg_location" {
  description = "Location (region) of the Azure resource group"
  type        = string
  default     = "East US"
}

####################################
#### VIRTUAL MACHINES VARIABLES ####
####################################

variable "create_vms" {
  description = "Flag to determine whether to create virtual machines or not"
  type        = bool
  default     = true
}

variable "admin_username" {
  description = "Administrator username for the virtual machines"
  type        = string
  default     = "usradmin"
}

variable "admin_password" {
  description = "Administrator password for the virtual machines"
  type        = string
  default     = "P@ssWord!!$4"
}

