terraform {
  backend "azurerm" {
    resource_group_name  = "rg-webappdemosa-adiaz"
    storage_account_name = "sawebappdemoadiaz"
    container_name       = "webapptfstate"
    key                  = "stateActions.tfstate"
  }
}