terraform {
  required_version = ">= 1.6.0"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = ">= 1.17.0"
    }
  }
}
