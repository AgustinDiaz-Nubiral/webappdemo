# main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource-group" {
  name     = "appDemo-resources"
  location = "eastus"

  tags = {
    Environment = "Production"
    Department  = "IT"
    Project     = "HelloWorldApp"
  }
}

resource "azurerm_app_service_plan" "service-plan" {
  name                = "appDemo-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.appDemo-resource
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app-service" {
  name                = "appDemo-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}