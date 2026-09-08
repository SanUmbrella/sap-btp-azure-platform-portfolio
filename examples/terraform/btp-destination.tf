# Representative sanitized pattern, not a complete deployable environment.

variable "btp_subaccount_id" {
  description = "SAP BTP subaccount identifier supplied outside this public example."
  type        = string
}

variable "remote_url" {
  description = "Remote HTTPS endpoint supplied outside this public example."
  type        = string
}

resource "btp_subaccount_destination_generic" "aks_probe" {
  subaccount_id = var.btp_subaccount_id
  name          = "AKS_PROBE_API"
  type          = "HTTP"

  properties = {
    URL               = var.remote_url
    ProxyType         = "Internet"
    Authentication    = "NoAuthentication"
    "HTML5.DynamicDestination" = "true"
  }
}
