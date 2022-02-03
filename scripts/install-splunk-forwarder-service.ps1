# this script downloads the Splunk Universal Forwarder and installs it in a Windows machine

[CmdletBinding()]

param
(
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$splunk_username,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$splunk_password,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$splunk_pass4symmkey,
    [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$splunk_group
)

$password = ConvertTo-SecureString -AsPlainText $splunkPassword -Force
$msiDownload = "https://download.splunk.com/products/universalforwarder/releases/8.2.4/windows/splunkforwarder-8.2.4-87e2dda940d1-x64-release.msi"
$msiFile = $env:Temp + "\splunkforwarder-8.2.4-87e2dda940d1-x64-release.msi"
$receiver = 'splunk-cm-prod-vm00.platform.hmcts.net:8089'
$msiArguments = @(
    "DEPLOYMENT_SERVER='splunk-lm-prod-vm00.platform.hmcts.net:8089'"
    "RECEIVING_INDEXER=$receiver"
    "WINEVENTLOG_SEC_ENABLE=1"
    "WINEVENTLOG_SYS_ENABLE=1"
    "WINEVENTLOG_APP_ENABLE=1"
    "WINEVENTLOG_FWD_ENABLE=1"
    "WINEVENTLOG_SET_ENABLE=1"
    "AGREETOLICENSE=Yes"
    "SERVICESTARTTYPE=AUTO"
    "LAUNCHSPLUNK=1"
    "SPLUNKUSERNAME=$splunk_username"
    "SPLUNKPASSWORD=$password"
    "/quiet"
)
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing Splunk"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
(New-Object System.Net.WebClient).DownloadFile($msiDownload, $msiFile)
Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList '/i', "$msiFile", "$msiArguments" -Wait -Verbose

If ((Get-Service -name splunkforwarder).Status -ne "Running") {
    throw "Splunk forwarder service not running"
}

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Splunk installation successful"

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Configuring outsputs.conf"

# Configure outputs.conf

@"
indexer_discovery:hmcts_cluster_manager]
pass4SymmKey = $splunk_pass4symmkey
master_uri = "https://$receiver"

[tcpout:$splunk_group]
autoLBFrequency = 30
forceTimebasedAutoLB = true
indexerDiscovery = hmcts_cluster_manager
useACK=true

[tcpout]
defaultGroup = $splunk_group
"@ > "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf"