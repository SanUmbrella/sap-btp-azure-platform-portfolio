data "cloudfoundry_org" "selected" {
  name = var.cf_org_name
}

data "cloudfoundry_space" "selected" {
  name = var.cf_space_name
  org  = data.cloudfoundry_org.selected.id
}

resource "cloudfoundry_service_instance" "xsuaa" {
  name         = "platform-probe-xsuaa"
  type         = "managed"
  space        = data.cloudfoundry_space.selected.id
  service_plan = "application"

  parameters = templatefile("${path.module}/xs-security.json", {
    space = var.cf_space_name
  })
}

resource "cloudfoundry_service_instance" "destination" {
  name         = "platform-probe-destination"
  type         = "managed"
  space        = data.cloudfoundry_space.selected.id
  service_plan = "lite"
}

resource "cloudfoundry_service_instance" "connectivity" {
  name         = "platform-probe-connectivity"
  type         = "managed"
  space        = data.cloudfoundry_space.selected.id
  service_plan = "lite"
}
