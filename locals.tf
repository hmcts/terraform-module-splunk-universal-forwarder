locals {
  cse_script = "./${var.script_name} ${var.splunk_username} ${var.splunk_password} ${var.splunk_group}"
  script_uri = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/Splunk-change/scripts/${var.script_name}"
}

