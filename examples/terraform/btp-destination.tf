# Representative sanitized pattern, not a complete deployable environment.

variable "btp_subaccount_id" {
  description = "SAP BTP subaccount identifier supplied outside this public example."
  type        = string
}

variable "aks_probe_url" {
  description = "Remote HTTPS endpoint supplied outside this public example."
  type        = string
}

resource "btp_subaccount_destination_generic" "aks_probe" {
  subaccount_id = var.btp_subaccount_id

  destination_configuration = jsonencode({
    Name           = "aks-probe-api"
    Type           = "HTTP"
    ProxyType      = "Internet"
    URL            = var.aks_probe_url
    Authentication = "NoAuthentication"
  })
}
