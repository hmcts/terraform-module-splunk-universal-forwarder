locals {
  cse_script  = "./${var.script_name} ${var.splunk_username} ${var.splunk_password}"
  script_uri  = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/dtspo-3774-dynatrace-private-synthetic/scripts/${var.script_name}"
}