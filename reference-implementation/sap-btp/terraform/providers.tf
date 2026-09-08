terraform {
  required_version = ">= 1.15.0"

  backend "s3" {}

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.25.0"
    }

    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.17.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.8.0"
    }
  }
}

provider "btp" {
  globalaccount = var.btp_globalaccount_subdomain
}

provider "cloudfoundry" {}
