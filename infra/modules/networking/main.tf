#Creation Vnet & Subnet----------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "example_vnet" {
name                = "vnet-webappad-prod-eastus-01"
address_space       = ["10.0.0.0/16"]
location            = var.resource_group_location
resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "gateway_subnet" {
name                 = "gwsubnet-webappad-prod-eastus-01"
resource_group_name  = var.resource_group_name
virtual_network_name = azurerm_virtual_network.example_vnet.name
address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "webapp_subnet" {
name                 = "subnet-webappad-prod-eastus-01"
resource_group_name  = var.resource_group_name
virtual_network_name = azurerm_virtual_network.example_vnet.name
address_prefixes     = ["10.0.1.0/24"]
}


#Configuration VPN Gateway-----------------------------------------------------------------------------------------------------

resource "azurerm_public_ip" "vpn_gateway_ip" {
name                = "vpn-gateway-ip-webappad-prod-eastus-01"
location            = var.resource_group_location
resource_group_name = var.resource_group_name
allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
name                = "vpn-gateway-webapp-prod-eastus-01"
location            = var.resource_group_location
resource_group_name = var.resource_group_name
sku = "Basic"
type     = "Vpn"
vpn_type = "RouteBased"

active_active = false
enable_bgp    = false


ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
}
}


#Connection Site-to-Site--------------------------------------------------------------------------------------------------------

resource "azurerm_local_network_gateway" "local_gateway" {
  name                = "local-gateway-webappad-prod-eastus-01"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  gateway_address     = "192.168.0.1"
  address_space       = ["192.168.0.0/24"] # Rango de IPs de tu red local
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                = "vpn-connection-webappad-prod-eastus-01"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type                         = "IPsec"
  virtual_network_gateway_id   = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id     = azurerm_local_network_gateway.local_gateway.id

  shared_key                   = "TclumPtjxEdXj61Cm6oUYFsCVs6VwUC+kf296AUpnvA=" # Clave compartida para la VPN
}


#Integration Web App - VNet----------------------------------------------------------------------------------------------------

resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id      = var.app_service_id
  subnet_id = azurerm_subnet.webapp_subnet.id
}
