variable "auto_upgrade_minor_version" {
  description = "Automatically upgrade to new minor version when available."
  default     = false
  type        = bool
}

variable "create_managed_identity" {
  description = "Creates user assigned managed identity and access policy for key vault access."
  default     = false
  type        = bool
}

variable "extension_name" {
  description = "Name label of custom script extension."
  default     = "splunk-universal-forwarder"
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

variable "managed_identity_name" {
  description = "VM/VMSS User assigned managed identity name."
  default     = ""
}

variable "managed_identity_location" {
  description = "VM/VMSS User assigned managed identity location."
  default     = ""
}

variable "managed_identity_rg" {
  description = "VM/VMSS User assigned managed identity resource group name."
  default     = ""
}

variable "splunk_key_vault_id" {
  description = "Id of keyvault storing splunk secrets."
}

variable "type_handler_version" {
  description = "Type handler version number"
  default = "2.1"
}

variable "virtual_machine_scale_set_id" {
  description = "Virtual machine scale set resource id."
}

variable "virtual_machine_id" {
  description = "Virtual machine resource id."
}

