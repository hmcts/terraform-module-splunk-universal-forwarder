data "azurerm_key_vault" "kv" {
  provider            = azurerm.soc
  name                = var.splunk_vault_name
  resource_group_name = var.splunk_vault_rg
}

data "azurerm_key_vault_secret" "splunk_username" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = var.splunk_username_secret
}

data "azurerm_key_vault_secret" "splunk_password" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = var.splunk_password_secret
}