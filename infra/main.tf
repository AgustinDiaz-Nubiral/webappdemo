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
  name                = "acrappdemoadiaz"
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
  sku_name            = "S1"

  tags                = local.tags
}


#Create Web App----------------------------------------------------------------------------------------------

resource "azurerm_linux_web_app" "webappoc" {
  name                = "webappdemo-adiaz"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appplan.id

  tags                = local.tags

  site_config {
    minimum_tls_version = "1.2"
    always_on = true
  }

  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }

}

# Slot de QA para la Web App
resource "azurerm_linux_web_app_slot" "qa_slot" {
  name                = "qa"
  app_service_id    = azurerm_linux_web_app.webappoc.id  # Usar el nombre del web app
  
  site_config {
    minimum_tls_version = "1.2"
    always_on = true  
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
      "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
      "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
      "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
      "DOCKER_CUSTOM_IMAGE_NAME"        = "acrappdemoadiaz.azurecr.io/myapp:qa"
    }    
  }

  

  



