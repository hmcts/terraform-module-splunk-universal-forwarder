locals {
  cse_script = "./${var.script_name} ${var.splunk_username} ${var.splunk_password} ${var.splunk_pass4symmkey} ${var.splunk_group}"
  script_uri = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/master/scripts/${var.script_name}"
  ps_script = jsonencode({
    commandToExecute = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath install-splunk-forwarder-service.ps1\" && powershell -ExecutionPolicy Unrestricted -File install-splunk-forwarder-service.ps1 -username ${data.template_file.tf.vars.username} -password ${data.template_file.tf.vars.password} -pass4symmkey ${data.template_file.tf.vars.pass4symmkey} -group ${data.template_file.tf.vars.group}"
  }) 
  commandToExecute = var.os_type == "Linux" ? local.cse_script && local.script_uri : local.ps_script


data "template_file" "tf" {
    template = file("${path.module}/scripts/install-splunk-forwarder-service.ps1")
    vars = {
        username                    = "${var.splunk_username}"
        password                    = "${var.splunk_password}"
        pass4symmkey                = "${var.splunk_pass4symmkey}"
        group                       = "${var.splunk_group}"
  }
}

}
