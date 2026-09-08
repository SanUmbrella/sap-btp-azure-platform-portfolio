data "cloudfoundry_domain" "apps" {
  name = var.cf_domain
}

resource "cloudfoundry_route" "backend" {
  space  = data.cloudfoundry_space.selected.id
  domain = data.cloudfoundry_domain.apps.id
  host   = var.backend_host

  destinations = [
    {
      app_id = cloudfoundry_app.backend.id
    }
  ]
}

resource "cloudfoundry_route" "approuter" {
  space  = data.cloudfoundry_space.selected.id
  domain = data.cloudfoundry_domain.apps.id
  host   = var.approuter_host

  destinations = [
    {
      app_id = cloudfoundry_app.approuter.id
    }
  ]
}
