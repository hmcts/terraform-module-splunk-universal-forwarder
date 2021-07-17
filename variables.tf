variable "auto_upgrade_minor_version" {
  description = "Automatically upgrade to new minor version when available."
  default     = false
  type        = bool
}

variable "extension_name" {
  description = "Custom script extension name label."
  default     = "splunk-universal-forwarder"
  type        = string
}

variable "is_resource_vm" {
  description = "Determines if 'azurerm_virtual_machine_extension' should be deployed."
  default     = false
  type        = bool
}

variable "is_resource_vmss" {
  description = "Determines if 'azurerm_virtual_machine_scale_set_extension' should be deployed."
  default     = false
  type        = bool
}

variable "splunk_vault_name" {
  description = "Name of keyvault storing splunk secrets."
  type        = string
}

variable "splunk_vault_rg" {
  description = "Resource group name of keyvault storing splunk secrets."
  type        = string
}

variable "splunk_username_secret" {
  description = "Splunk universal forwarder local admin username key vault secret name ."
  type        = string
}

variable "splunk_password_secret" {
  description = "Splunk universal forwarder local admin password key vault secret name."
  type        = string
}

variable "script_name" {
  description = "Splunk universal forwarder install script stored in public Github repository"
  default     = "install-splunk-forwarder-service.sh"
  type        = string
}

variable "type_handler_version" {
  description = "Type handler version number"
  default     = "2.1"
  type        = string
}

variable "virtual_machine_scale_set_id" {
  description = "Virtual machine scale set resource id."
  default     = ""
  type        = string
}

variable "virtual_machine_id" {
  description = "Virtual machine resource id."
  default     = ""
  type        = string
}

