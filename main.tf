resource "azurerm_virtual_machine_scale_set_extension" "splunk-uf" {

  count = var.virtual_machine_type == "vmss" ? 1 : 0

  name                         = var.extension_name
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = var.type_handler_version
  auto_upgrade_minor_version   = var.auto_upgrade_minor_version

  protected_settings = <<PROTECTED_SETTINGS
    {
      "fileUris": ["${local.script_uri}"],
      "commandToExecute": "${local.cse_script}"
    }
    PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "splunk-uf" {

  count = var.virtual_machine_type == "vm" ? 1 : 0

  name                       = var.extension_name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = lower(var.os_type) == "linux" ? "Microsoft.Azure.Extensions" : lower(var.os_type) == "windows" ? "Microsoft.Compute" : null
  type                       = lower(var.os_type) == "linux" ? "CustomScript" : lower(var.os_type) == "windows" ? "CustomScriptExtension" : null
  type_handler_version       = lower(var.os_type) == "linux" ? var.type_handler_version : var.type_handler_version_windows
  auto_upgrade_minor_version = var.auto_upgrade_minor_version
  protected_settings         = <<PROTECTED_SETTINGS
    {
      %{if var.os_type == "Linux"}
      "fileUris": ["${local.script_uri}"],
      "commandToExecute": "${local.cse_script}"
      %{else}
      "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath install-splunk-forwarder-service.ps1\" && powershell -ExecutionPolicy Unrestricted -File install-splunk-forwarder-service.ps1 -username ${var.splunk_username} -password ${var.splunk_password} -pass4symmkey ${var.splunk_pass4symmkey} -group ${var.splunk_group}"
      %{endif}
    }
    PROTECTED_SETTINGS
}

// var.type_handler_version
data "template_file" "tf" {
  template = file("${path.module}/scripts/install-splunk-forwarder-service.ps1")
}
