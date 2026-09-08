terraform {
  required_version = ">= 1.6.0"

  backend "s3" {}

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = ">= 1.20.0"
    }

    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = ">= 1.17.0"
    }
  }
}

provider "btp" {
  globalaccount = var.btp_globalaccount_subdomain
}

provider "cloudfoundry" {
  api_url = var.cf_api_url
}
