data "cloudfoundry_org" "selected" {
  name = var.cf_org_name
}

data "cloudfoundry_space" "selected" {
  name = var.cf_space_name
  org  = data.cloudfoundry_org.selected.id
}

resource "cloudfoundry_service_instance" "xsuaa" {
  name  = "sap-btp-platform-probe-xsuaa"
  space = data.cloudfoundry_space.selected.id
  type  = "managed"

  service_offering_name = "xsuaa"
  service_plan_name     = "application"

  parameters = templatefile("${path.module}/xs-security.json", {
    approuter_route = "https://${var.approuter_host}.${var.cf_domain}/login/callback"
  })
}

resource "cloudfoundry_service_instance" "destination" {
  name  = "sap-btp-platform-probe-destination"
  space = data.cloudfoundry_space.selected.id
  type  = "managed"

  service_offering_name = "destination"
  service_plan_name     = "lite"
}

resource "cloudfoundry_service_instance" "connectivity" {
  name  = "sap-btp-platform-probe-connectivity"
  space = data.cloudfoundry_space.selected.id
  type  = "managed"

  service_offering_name = "connectivity"
  service_plan_name     = "lite"
}
