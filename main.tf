resource "azurerm_resource_group" "api_rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_resource_group" "test_rg" {
    name = var.test_rg_name
    location = "East US"
    tags     = {
        "costcenter" = "101"
        "dept"       = "finance"
        "env"        = "test"
    }
}

resource "azurerm_virtual_network" "testNetwork" {
  location = azurerm_resource_group.test_rg.location
  address_space = ["10.0.0.0/19","192.168.0.0/24"]
  name = "test-nw"
  resource_group_name = azurerm_resource_group.test_rg.name
    tags = {
       "env" = "test"
    }

}

resource "azurerm_subnet" "defaultsubnet" {
  name = "default"
  resource_group_name = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.testNetwork.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "dbsubnet" {
  name = "db"
  resource_group_name = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.testNetwork.name
  address_prefixes = ["10.0.2.0/24"]
  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "appsubnet" {
  name = "app"
  resource_group_name = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.testNetwork.name
  address_prefixes = ["10.0.1.0/24"]
}
