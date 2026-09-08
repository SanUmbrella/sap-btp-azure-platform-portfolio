resource "cloudfoundry_app" "backend" {
  name       = "platform-probe-backend"
  space      = data.cloudfoundry_space.selected.id
  path       = "../app"
  memory     = 256
  disk_quota = 512
  strategy   = "rolling"

  environment = {
    AKS_PROBE_DESTINATION = btp_subaccount_destination_generic.aks_probe.name
    ONPREM_DESTINATION    = btp_subaccount_destination_generic.onprem_mock.name
  }
}

resource "cloudfoundry_app" "approuter" {
  name       = "platform-probe-approuter"
  space      = data.cloudfoundry_space.selected.id
  path       = "../approuter"
  memory     = 256
  disk_quota = 512
  strategy   = "rolling"

  environment = {
    destinations = jsonencode([
      {
        name             = "backend"
        url              = "https://${var.backend_host}.${var.cf_domain}"
        forwardAuthToken = true
        timeout          = 30000
      }
    ])
  }
}
