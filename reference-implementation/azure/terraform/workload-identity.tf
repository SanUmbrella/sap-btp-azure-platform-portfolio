resource "azurerm_user_assigned_identity" "probe" {
  name                = "aks-probe-workload"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
}

resource "azurerm_federated_identity_credential" "probe" {
  name                = "aks-probe-serviceaccount"
  resource_group_name = azurerm_resource_group.lab.name
  parent_id           = azurerm_user_assigned_identity.probe.id
  issuer              = azurerm_kubernetes_cluster.lab.oidc_issuer_url
  audience            = ["api://AzureADTokenExchange"]
  subject             = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}

resource "azurerm_role_assignment" "key_vault_secret_user" {
  scope                = azurerm_key_vault.probe.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.probe.principal_id
}
