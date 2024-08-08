# main.tf
# LOCALS
locals {
  tags = {
    Owner      = "Pod2"
    CreatedBy  = "AgustinDiaz"
    Project    = "pocwa"
    Pod        = "2"
    Coe        = "1"
    Deadline   = "SERVICIOS"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location

tags = local.tags
}

/*resource "azurerm_container_registry" "acr" {
  name                = "acrappdemopoc"
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  sku                 = "Basic"
  /*admin_enabled       = true

  tags = {
    environment = "production"
  }
}*/

resource "azurerm_storage_account" "storage-account" {
  name                     = "sawebapppoc-ad"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_service_plan" "appplan" {
  name                = "appdemo-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

/*resource "azurerm_app_service" "app-service" {
  name                = "appdemo-appservice"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  app_service_plan_id = azurerm_app_service_plan.appplan.id
}*/

resource "azurerm_linux_web_app" "webappoc" {
  name                = "webapppocdemo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appplan.id
  site_config {
    always_on = true
}
}
  