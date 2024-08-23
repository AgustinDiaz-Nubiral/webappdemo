terraform {
  required_providers {
     azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  //subscription_id = "63e68764-6c1e-4010-a6bf-0c967f06188c"
}