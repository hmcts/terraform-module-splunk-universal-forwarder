locals {
  cse_script = "./${var.script_name} ${var.splunk_username} ${var.splunk_password} ${var.splunk_group}"
  script_uri = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/master/scripts/${var.script_name}"
}

locals {
  common_tags = module.ctags.common_tags
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = var.product
  builtFrom   = var.builtFrom
}