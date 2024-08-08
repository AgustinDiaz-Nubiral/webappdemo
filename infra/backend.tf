terraform {
  backend "azurerm" {
    storage_account_name = "sawebappdemoadiaz"
    container_name       = "webapptfstate"
    key                  = "stateActions.tfstate"
  }
}