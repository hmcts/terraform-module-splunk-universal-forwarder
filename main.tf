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
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version
  protected_settings = <<PROTECTED_SETTINGS
    {
      %{if var.os_type == "Linux"}
      "fileUris": ["${local.script_uri}"],
      "commandToExecute": "${local.cse_script}"
      %{else}
      "commandToExecute": "${local.ps_script}"
      %{endif}
    }
    PROTECTED_SETTINGS
}

data "template_file" "tf" {
    template = file("${path.module}/scripts/install-splunk-forwarder-service.ps1")
    vars = {
        username                    = "${var.splunk_username}"
        password                    = "${var.splunk_password}"
        pass4symmkey                = "${var.splunk_pass4symmkey}"
        group                       = "${var.splunk_group}"
  }
}