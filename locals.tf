locals {
  cse_script  = "./${var.script_name} ${data.azurerm_key_vault_secret.splunk_username.value} ${data.azurerm_key_vault_secret.splunk_password.value}"
  script_uri  = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/dtspo-3774-dynatrace-private-synthetic/scripts/${var.script_name}"
}