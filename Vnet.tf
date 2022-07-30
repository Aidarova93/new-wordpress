resource "azurerm_virtual_network" "Team2" {
  name                = "Team2-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.Team2.name
  tags                = var.tags
}

resource "azurerm_subnet" "Team2" {
  name                 = "Team2-subnet"
  resource_group_name  = azurerm_resource_group.Team2.name
  virtual_network_name = azurerm_virtual_network.Team2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "Team2" {
  name                = "Team2-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.Team2.name
  allocation_method   = "Static"
  domain_name_label   = random_string.qwer.result
  tags                = var.tags
}
