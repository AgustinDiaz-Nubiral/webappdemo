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
  name                = "acrappdemo-adiaz"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  
  tags = local.tags
}


#Create Service Plan------------------------------------------------------------------------------------------

resource "azurerm_service_plan" "appplan" {
  name                = "appdemo-appserviceplan-adiaz"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags                = local.tags
}


#Create Web App-----------------------------------------------------------------------------------------------

resource "azurerm_linux_web_app" "webappoc" {
  name                = "webappdemo-adiaz"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appplan.id

  tags                = local.tags

  site_config {
    minimum_tls_version = "1.2"
    always_on = true
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/my-app:latest"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }

  tags = {
    environment = "production"
  }
}


# Asignar permisos ACR Pull para la Web App ------------------------------------------------------------------

/*resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_linux_web_app.webappoc.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}*/
  