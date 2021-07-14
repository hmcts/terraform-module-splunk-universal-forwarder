resource "azurerm_virtual_machine_scale_set_extension" "splunk-uf" {

  count = var.is_resource_vmss ? 1 : 0

  name                         = var.extension_name
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = var.type_handler_version
  auto_upgrade_minor_version   = var.auto_upgrade_minor_version

  settings = <<SETTINGS
    {
      "script": "${local.cse_script}"
    }
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "splunk-uf" {

  count = var.is_resource_vm ? 1 : 0

  name                       = var.extension_name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version

  settings = <<SETTINGS
    {
      "script": "${local.cse_script}"
    }
    SETTINGS
}