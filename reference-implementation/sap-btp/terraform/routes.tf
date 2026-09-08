data "cloudfoundry_domain" "apps" {
  name = var.cf_domain
}

resource "cloudfoundry_route" "backend" {
  space  = data.cloudfoundry_space.selected.id
  domain = data.cloudfoundry_domain.apps.id
  host   = var.backend_host
}

resource "cloudfoundry_route" "approuter" {
  space  = data.cloudfoundry_space.selected.id
  domain = data.cloudfoundry_domain.apps.id
  host   = var.approuter_host
}

resource "cloudfoundry_route_mapping" "backend" {
  app   = cloudfoundry_app.backend.id
  route = cloudfoundry_route.backend.id
}

resource "cloudfoundry_route_mapping" "approuter" {
  app   = cloudfoundry_app.approuter.id
  route = cloudfoundry_route.approuter.id
}
