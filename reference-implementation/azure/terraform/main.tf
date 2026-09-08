resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "probe" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "lab" {
  name                = var.cluster_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  network_plugin            = "azure"
  network_plugin_mode       = "overlay"
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.probe.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.lab.kubelet_identity[0].object_id
}
