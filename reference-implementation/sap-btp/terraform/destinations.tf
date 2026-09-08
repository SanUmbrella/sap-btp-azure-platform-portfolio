resource "btp_subaccount_destination_generic" "aks_probe" {
  subaccount_id = var.btp_subaccount_id
  name          = "AKS_PROBE_API"
  type          = "HTTP"

  properties = {
    URL                        = var.aks_probe_url
    ProxyType                  = "Internet"
    Authentication             = "NoAuthentication"
    "HTML5.DynamicDestination" = "true"
  }
}

resource "btp_subaccount_destination_generic" "onprem_mock" {
  subaccount_id = var.btp_subaccount_id
  name          = "ONPREM_MOCK_API"
  type          = "HTTP"

  properties = {
    URL            = "http://${var.onprem_virtual_host}"
    ProxyType      = "OnPremise"
    Authentication = "NoAuthentication"
  }
}
