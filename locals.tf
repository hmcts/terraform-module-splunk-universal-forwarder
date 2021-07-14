locals {
  cse_script  = filebase64("${path.module}/../scripts/install-splunk-forwarder-service.sh")
}