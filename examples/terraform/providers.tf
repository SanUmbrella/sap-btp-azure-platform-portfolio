terraform {
  required_version = ">= 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.2.0"
    }

    btp = {
      source  = "SAP/btp"
      version = "1.25.0"
    }
  }
}

variable "btp_globalaccount_subdomain" {
  description = "BTP global account subdomain supplied outside this public example."
  type        = string
}

provider "azurerm" {
  features {}
}

provider "btp" {
  globalaccount = var.btp_globalaccount_subdomain
}
