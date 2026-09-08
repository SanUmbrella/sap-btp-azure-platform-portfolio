resource "azurerm_user_assigned_identity" "probe" {
  name                = "aks-probe-kv-reader"
  resource_group_name = azurerm_resource_group.security.name
  location            = azurerm_resource_group.security.location
  tags                = var.common_tags
}

resource "azurerm_federated_identity_credential" "probe" {
  name = "fic-aks-probe"

  user_assigned_identity_id = azurerm_user_assigned_identity.probe.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer  = azurerm_kubernetes_cluster.lab.oidc_issuer_url
  subject = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}

resource "azurerm_role_assignment" "key_vault_secret_user" {
  scope                = azurerm_key_vault.probe.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.probe.principal_id
  principal_type       = "ServicePrincipal"

  skip_service_principal_aad_check = true
}
