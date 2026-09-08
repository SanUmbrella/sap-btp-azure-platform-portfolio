resource "btp_subaccount_destination_generic" "aks_probe" {
  subaccount_id = var.btp_subaccount_id

  destination_configuration = jsonencode({
    Name           = "azure-aks-probe"
    Description    = "SAP BTP to Azure AKS integration endpoint"
    Type           = "HTTP"
    ProxyType      = "Internet"
    URL            = var.aks_probe_url
    Authentication = "NoAuthentication"
  })
}

resource "btp_subaccount_destination_generic" "onprem_mock" {
  subaccount_id = var.btp_subaccount_id

  destination_configuration = jsonencode({
    Name           = "onprem-hello"
    Description    = "Standalone SAP Cloud Connector lab endpoint"
    Type           = "HTTP"
    ProxyType      = "OnPremise"
    ProxyProtocol  = "HTTP"
    URL            = "http://${var.onprem_virtual_host}:18080"
    Authentication = "NoAuthentication"
  })
}

resource "btp_subaccount_destination_generic" "hello_backend" {
  subaccount_id = var.btp_subaccount_id

  destination_configuration = jsonencode({
    Name                     = "hello-backend"
    Description              = "Cloud Foundry backend application route"
    Type                     = "HTTP"
    ProxyType                = "Internet"
    URL                      = "https://${var.backend_host}.${var.cf_domain}"
    Authentication           = "NoAuthentication"
    "HTML5.ForwardAuthToken" = "true"
  })
}
