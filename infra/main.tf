# main.tf

# LOCALS
locals {
  tags = {
    Owner      = var.owner
    CreatedBy  = var.createdby
    Project    = var.project
    Pod        = var.pod
    Coe        = var.coe
    Deadline   = var.deadline
  }
}

# RESOURCES


#Create Resource Group-----------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location

  tags = local.tags
}

#Create Azure Container Registry-------------------------------------------------------------------------------

resource "azurerm_container_registry" "acr" {
  name                = "acrappdemopoc"
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  sku                 = "Basic"
  admin_enabled       = true
}


#Create Storage Account----------------------------------------------------------------------------------------

resource "azurerm_storage_account" "storage-account" {
  name                     = "sawebapppoc-ad"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags                = local.tags
}


#Create Service Plan------------------------------------------------------------------------------------------

resource "azurerm_service_plan" "appplan" {
  name                = "appdemo-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags                = local.tags
}


#Create Web App-----------------------------------------------------------------------------------------------

resource "azurerm_linux_web_app" "webappoc" {
  name                = "webapppocdemo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appplan.id

  tags                = local.tags

  site_config {
    minimum_tls_version = "1.2"
    always_on = true
  }
}
  