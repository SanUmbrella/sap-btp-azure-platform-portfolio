data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "probe" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization = true
}

resource "azurerm_key_vault_secret" "verification" {
  name         = "probe-verification"
  value        = "sanitized-placeholder-value"
  key_vault_id = azurerm_key_vault.probe.id
}
