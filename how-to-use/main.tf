module "vpc_hub_spoke" {
  source = "./module-vpc"

  # Virtual Machine Configuration
  create_vms      = true
  admin_username  = "useradm"
  admin_password  = "P@ssw0rd1234"
  
  spokes = [
    {
      name = "spoke1"
      address_space = "10.1.0.0/16"
      subnets = [
        {
          name = "servers"
          address_prefixes = ["10.1.0.0/24"]
        }
      ]
    },
    {
      name = "spoke2"
      address_space = "10.2.0.0/16"
      subnets = [
        {
          name = "servers"
          address_prefixes = ["10.2.0.0/24"]
        }
      ]
    }
  ]
}