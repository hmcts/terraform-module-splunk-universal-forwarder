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

variable "splunk_username" {
  description = "Splunk universal forwarder local admin username - read input from keyvault."
  type        = string
}

variable "splunk_password" {
  description = "Splunk universal forwarder local admin password - read input from keyvault."
  type        = string
}

variable "tags" {
  description = "tags"
  type        = string
}

# variable "splunk_pass4symmkey" {
#   description = "Splunk universal forwarder communication security key - read input from keyvault."
#   type        = string
# }

variable "splunk_group" {
  description = "Splunk universal forwarder global target group."
  default     = "dynatrace_forwarders"
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

variable "type_handler_version_windows" {
  description = "Type handler version number for Windows VMs"
  default     = "1.9"
  type        = string
}

variable "virtual_machine_type" {
  description = "vm or vmss."
  type        = string
}

variable "os_type" {
  description = "Windows or Linux."
  type        = string
  default     = "Linux"
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
