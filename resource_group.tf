resource "azurerm_resource_group" "rg_er" {
  name     = var.rg_name
  location = var.rg_location
}