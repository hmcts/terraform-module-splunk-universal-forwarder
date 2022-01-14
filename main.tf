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
      "fileUris": ["${local.script_uri}"],
      "commandToExecute": "${local.cse_script}"
    }
    PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "splunk-uf-windows" {

  count =  var.os_type == "Windows" ? 1 : 0

  name                       = var.extension_name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version

  protected_settings = <<PROTECTED_SETTINGS
    { 
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath \scripts\install-splunk-forwarder-service.ps1\" && powershell -ExecutionPolicy Unrestricted -File \scripts\install-splunk-forwarder-service.ps1 -username ${data.template_file.tf.vars.username} -password ${data.template_file.tf.vars.password} -pass4symmkey ${data.template_file.tf.vars.pass4symmkey} -splunk_group ${data.template_file.tf.vars.group}"
     
    }
    PROTECTED_SETTINGS

}

data "template_file" "tf" {
    template = "${file("./scripts/install-splunk-forwarder-service.ps1")}"
    vars = {
        username                    = "${var.splunk_username}"
        password                    = "${var.splunk_password}"
        pass4symmkey                = "${var.splunk_pass4symmkey}"
        group                       = "${var.splunk_group}"
  }
}