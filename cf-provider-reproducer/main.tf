# Planned minimal reproducer skeleton.
# Do not add credentials or live platform identifiers to this file.

variable "cf_api_url" {
  type = string
}

variable "cf_org_name" {
  type = string
}

variable "cf_space_name" {
  type = string
}

provider "cloudfoundry" {
  api_url = var.cf_api_url
}

data "cloudfoundry_org" "selected" {
  name = var.cf_org_name
}

data "cloudfoundry_space" "selected" {
  name = var.cf_space_name
  org  = data.cloudfoundry_org.selected.id
}

# Add the smallest app, service instance and service credential binding needed
# to reproduce or disprove the adoption-time replacement behavior.
