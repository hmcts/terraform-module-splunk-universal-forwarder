[CmdletBinding()]

param
(
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$username,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$password,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$pass4symmkey,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$group
)

# Setup
$installerURI = 'https://download.splunk.com/products/universalforwarder/releases/8.2.4/windows/splunkforwarder-8.2.4-87e2dda940d1-x64-release.msi'
$installerFile = $env:Temp + "\splunkforwarder-8.2.4-87e2dda940d1-x64-release.msi"
$indexServer = 'splunk-cm-prod-vm00.platform.hmcts.net:9997'
$deploymentServer = 'splunk-lm-prod-vm00.platform.hmcts.net:8089'

# Downloading & Installing Splunk Universal Forwarder
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Splunk Universal Forwarder installer."
(New-Object System.Net.WebClient).DownloadFile($installerURI, $installerFile)
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing Splunk Universal Forwarder."
Start-Process -FilePath msiexec.exe -ArgumentList "/i $installerFile DEPLOYMENT_SERVER=$deploymentServer RECEIVING_INDEXER=$indexServer WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_FWD_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 AGREETOLICENSE=Yes SERVICESTARTTYPE=AUTO LAUNCHSPLUNK=0 SPLUNKUSERNAME=$username SPLUNKPASSWORD=$password /quiet" -Wait

# Configuration
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Editing configuration."
@"
[indexer_discovery:hmcts_cluster_manager]
pass4SymmKey = $pass4symmkey
master_uri = https://$indexServer

[tcpout:$group]
autoLBFrequency = 30
forceTimebasedAutoLB = true
indexerDiscovery = hmcts_cluster_manager
useACK=true

[tcpout]
defaultGroup = $group
"@ > "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf"

# Installation verification
Restart-Service -Name splunkforwarder
$splunk = Get-Process -Name "splunkd" -ErrorAction SilentlyContinue
if ($null -ne $splunk) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Splunk Universal Forwarder has been installed successfully."
    exit 0
}
else {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Splunk Universal Forwarder installation failed."
    exit 1
}