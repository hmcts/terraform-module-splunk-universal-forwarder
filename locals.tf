locals {
  cse_script  = "${path.module}/scripts/install-splunk-forwarder-service.sh ${data.azurerm_key_vault_secret.splunk_username.value} ${data.azurerm_key_vault_secret.splunk_password.value}"
}