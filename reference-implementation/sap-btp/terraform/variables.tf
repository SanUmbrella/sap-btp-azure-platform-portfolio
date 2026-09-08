variable "btp_globalaccount_subdomain" {
  description = "BTP global account subdomain supplied outside this public repository."
  type        = string
}

variable "btp_subaccount_id" {
  description = "BTP subaccount ID supplied outside this public repository."
  type        = string
}

variable "cf_org_name" {
  description = "Cloud Foundry org name supplied outside this public repository."
  type        = string
}

variable "cf_space_name" {
  description = "Cloud Foundry space name supplied outside this public repository."
  type        = string
}

variable "backend_host" {
  description = "Stable backend route host."
  type        = string
}

variable "approuter_host" {
  description = "Stable AppRouter route host."
  type        = string
}

variable "cf_domain" {
  description = "Cloud Foundry application domain."
  type        = string
}

variable "aks_probe_url" {
  description = "Sanitized HTTPS endpoint for the AKS probe path."
  type        = string
}

variable "onprem_virtual_host" {
  description = "Virtual host exposed through SAP Cloud Connector."
  type        = string
  default     = "onprem-api.internal.example"
}

variable "viewer_origin" {
  description = "Identity origin for the BTP role collection assignment."
  type        = string
  default     = "sap.default"
}

variable "viewer_user_name" {
  description = "User name or group identifier supplied outside this public repository."
  type        = string
}
