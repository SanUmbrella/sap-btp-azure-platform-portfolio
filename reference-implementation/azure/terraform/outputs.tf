output "aks_name" {
  value = azurerm_kubernetes_cluster.lab.name
}

output "aks_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.lab.oidc_issuer_url
}

output "acr_login_server" {
  value = azurerm_container_registry.probe.login_server
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.probe.client_id
}

output "workload_service_account_subject" {
  value = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}
