# main.tf



resource "azurerm_resource_group" "resource-group" {
  name     = var.rgname
  location = var.location

  tags = {
    CreateBy = "AgustinDiaz"
    Project  = "webapppocdemo"
    Pod      = "2"
    Deadline = "Servicios"
    Owner    = "Pod2"
  }
}

resource "azurerm_storage_account" "storage-account" {
  name                     = "sawebapppoc-ad"
  resource_group_name      = azurerm_resource_group.resource-group.name
  location                 = azurerm_resource_group.resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorgageV2"
}

resource "azurerm_app_service_plan" "appplan" {
  name                = "appdemo-appserviceplan"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app-service" {
  name                = "appdemo-appservice"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  app_service_plan_id = azurerm_app_service_plan.appplan.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}