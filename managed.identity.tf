resource "azurerm_user_assigned_identity" "mi" {

  count = var.create_managed_identity ? 1 : 0

  name                = var.managed_identity_name
  location            = var.managed_identity_location
  resource_group_name = var.managed_identity_rg
}

resource "azurerm_key_vault_access_policy" "splunk_vault" {

  count = var.create_managed_identity ? 1 : 0

  provider     = azurerm.splunk
  key_vault_id = var.splunk_key_vault_id
  object_id    = azurerm_user_assigned_identity.mi.principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "list",
    "get"
  ]
}