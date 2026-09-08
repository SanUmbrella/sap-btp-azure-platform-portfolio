locals {
  resource_group_names = {
    network  = "${var.resource_group_name}-network"
    security = "${var.resource_group_name}-security"
    platform = "${var.resource_group_name}-platform"
    aks      = "${var.resource_group_name}-aks"
  }
}

resource "azurerm_resource_group" "network" {
  name     = local.resource_group_names.network
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "security" {
  name     = local.resource_group_names.security
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "platform" {
  name     = local.resource_group_names.platform
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "aks" {
  name     = local.resource_group_names.aks
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.cluster_name}-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "aks_system" {
  name                 = "aks-system"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_prefixes.aks_system

  default_outbound_access_enabled = false
}

resource "azurerm_container_registry" "probe" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.common_tags
}

resource "azurerm_user_assigned_identity" "aks_control_plane" {
  name                = "${var.cluster_name}-control-plane"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  tags                = var.common_tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_subnet.aks_system.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_control_plane.principal_id
}

resource "azurerm_kubernetes_cluster" "lab" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.cluster_name

  sku_tier = "Free"

  node_provisioning_profile {
    mode = "Manual"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name            = "system"
    node_count      = 2
    vm_size         = "Standard_D4als_v6"
    vnet_subnet_id  = azurerm_subnet.aks_system.id
    os_disk_type    = "Managed"
    os_disk_size_gb = 32
    max_pods        = 30

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.aks_control_plane.id
    ]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"
  }

  tags = var.common_tags

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.probe.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.lab.kubelet_identity[0].object_id
}
