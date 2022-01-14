# this script downloads the Splunk Universal Forwarder and installs it in a Windows machine

[CmdletBinding()]

param 
( 
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$splunk_username,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$splunk_password,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$splunk_pass4symmkey,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$splunk_group
)

$password = ConvertTo-SecureString -AsPlainText $splunkPassword -Force
$msiDownload = "https://download.splunk.com/products/universalforwarder/releases/8.2.2.1/windows/splunkforwarder-8.2.2.1-ae6821b7c64b-x64-release.msi"
$msiFile = $env:Temp + "\splunkforwarder-8.2.2.1-ae6821b7c64b-x64-release.msi"
$msiArguments = @(
    "DEPLOYMENT_SERVER='splunk-lm-prod-vm00.platform.hmcts.net:8089'" 
    "RECEIVING_INDEXER='splunk-cm-prod-vm00.platform.hmcts.net:8089'"
    "WINEVENTLOG_SEC_ENABLE=0"
    "WINEVENTLOG_SYS_ENABLE=0" 
    "WINEVENTLOG_APP_ENABLE=0" 
    "AGREETOLICENSE=Yes" 
    "SERVICESTARTTYPE=AUTO" 
    "LAUNCHSPLUNK=1" 
    "SPLUNKUSERNAME=$splunkUsername"
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