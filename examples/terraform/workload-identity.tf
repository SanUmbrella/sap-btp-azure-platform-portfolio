# Representative sanitized pattern, not a complete deployable environment.

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "key_vault_scope" {
  description = "Key Vault resource ID supplied by the environment-specific stack."
  type        = string
}

resource "azurerm_user_assigned_identity" "aks_probe" {
  name                = "aks-probe-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "aks_probe" {
  name = "fic-aks-probe"

  user_assigned_identity_id = azurerm_user_assigned_identity.aks_probe.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer  = var.oidc_issuer_url
  subject = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = var.key_vault_scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_probe.principal_id
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_probe.client_id
}
