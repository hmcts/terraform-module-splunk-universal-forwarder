locals {
  cse_script = "./${var.script_name} ${var.splunk_username} ${var.splunk_password} ${var.splunk_pass4symmkey} ${var.splunk_group}"
  script_uri = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/master/scripts/${var.script_name}"

}
