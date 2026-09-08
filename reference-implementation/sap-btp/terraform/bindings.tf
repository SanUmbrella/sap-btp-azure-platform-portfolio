resource "cloudfoundry_service_credential_binding" "backend_xsuaa" {
  type             = "app"
  service_instance = cloudfoundry_service_instance.xsuaa.id
  app              = cloudfoundry_app.backend.id

  lifecycle {
    ignore_changes = [app]
  }
}

resource "cloudfoundry_service_credential_binding" "backend_destination" {
  type             = "app"
  service_instance = cloudfoundry_service_instance.destination.id
  app              = cloudfoundry_app.backend.id

  lifecycle {
    ignore_changes = [app]
  }
}

resource "cloudfoundry_service_credential_binding" "backend_connectivity" {
  type             = "app"
  service_instance = cloudfoundry_service_instance.connectivity.id
  app              = cloudfoundry_app.backend.id

  lifecycle {
    ignore_changes = [app]
  }
}

resource "cloudfoundry_service_credential_binding" "approuter_xsuaa" {
  type             = "app"
  service_instance = cloudfoundry_service_instance.xsuaa.id
  app              = cloudfoundry_app.approuter.id

  lifecycle {
    ignore_changes = [app]
  }
}
