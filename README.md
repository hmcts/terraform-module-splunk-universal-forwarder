# terraform-module-splunk-universal-forwarder

A Terraform module for installing Splunk Universal Forwarder (via an Azure Custom Script Extension) on a Linux virtual machine or virtual machine scale set.

## Requirements

A virtual machine or virtual machine scale set

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto_upgrade_minor_version | Automatically upgrade to new minor version when available . | `bool` | false | no |
| extension_name | VM extension name label. | `string` | splunk-universal-forwarder| no |
| splunk_username | Splunk universal forwarder local admin username - value should be passed from keyvault secret | `string` | n/a | yes |
| splunk_password | Splunk universal forwarder local admin password - value should be passed from keyvault secret | `string` | n/a | yes |
| splunk_pass4symmkey | Splunk universal forwarder communication security key - value should be passed from keyvault secret | `string` | n/a | yes |
| splunk_group | Splunk universal forwarder global target group | `string` | dynatrace_forwarders | yes |
| type_handler_version | VM extension type handler version | `string` | 2.1 | no |
| virtual_machine_type | Identifies whether target resource is 'vm' or 'vmss' | `string` | n/a | yes |
| virtual_machine_id | Virtual machine resource id | `string` | n/a | yes |
| virtual_machine_scale_set_id | Virtual machine scale set resource id | `string` | n/a | yes |


## Outputs

No outputs
