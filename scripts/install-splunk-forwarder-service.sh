#!/bin/bash

DOWNLOAD_URL="https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.2.0&product=universalforwarder&filename=splunkforwarder-8.2.0-e053ef3c985f-Linux-x86_64.tgz&wget=true"
INSTALL_FILE="splunkforwarder-8.2.0-e053ef3c985f-Linux-x86_64.tgz"
INSTALL_LOCATION="/opt"
DEPLOYMENT_SERVER_URI="splunk-lm-prod-vm00.platform.hmcts.net:8089"
FORWARD_SERVER_URI="splunk-cm-prod-vm00.platform.hmcts.net:8089"
UF_USERNAME=$1
UF_PASSWORD=$2
UF_PASS4SYMMKEY=$3

export SPLUNK_HOME="$INSTALL_LOCATION/splunkforwarder"

# Create boot-start systemd user
adduser --system --group splunk

# Install splunk forwarder
curl --retry 3 -# -L -o $INSTALL_FILE $DOWNLOAD_URL
tar xvzf $INSTALL_FILE -C $INSTALL_LOCATION
rm -rf $INSTALL_FILE
chown -R splunk:splunk $SPLUNK_HOME

if [  "$(systemctl is-active SplunkForwarder.service)" = "active"  ]; then
  $SPLUNK_HOME/bin/splunk stop
  sleep 10
fi

# Create splunk admin user
{
cat <<EOF
[user_info]
USERNAME = $UF_USERNAME
HASHED_PASSWORD = $($SPLUNK_HOME/bin/splunk hash-passwd $UF_PASSWORD)
EOF
} > $SPLUNK_HOME/etc/system/local/user-seed.conf

$SPLUNK_HOME/bin/splunk stop

# Start splunk forwarder
$SPLUNK_HOME/bin/splunk start --accept-license --no-prompt --answer-yes

# Set server name
$SPLUNK_HOME/bin/splunk set servername $hostname -auth $UF_USERNAME:$UF_PASSWORD
$SPLUNK_HOME/bin/splunk restart

# Configure deploymentclient.conf
{
cat <<EOF
[deployment-client]

[target-broker:deploymentServer]
# Settings for HMCTS DeploymentServer
targetUri = $DEPLOYMENT_SERVER_URI
EOF
} > $SPLUNK_HOME/etc/system/local/deploymentclient.conf


# Configure outputs.conf
{
cat <<EOF
[indexer_discovery:hmcts_cluster_manager]
pass4SymmKey = $UF_PASS4SYMMKEY
master_uri = https://$FORWARD_SERVER_URI

[tcpout:dynatrace_forwarders]
autoLBFrequency = 30
forceTimebasedAutoLB = true
indexerDiscovery = hmcts_cluster_manager
useACK=true

[tcpout]
defaultGroup = dynatrace_forwarders
EOF
} > $SPLUNK_HOME/etc/system/local/outputs.conf

# Create boot-start systemd service
$SPLUNK_HOME/bin/splunk stop
$SPLUNK_HOME/bin/splunk disable boot-start
sleep 10
$SPLUNK_HOME/bin/splunk enable boot-start -systemd-managed 1 -user splunk -group splunk
chown -R splunk:splunk $SPLUNK_HOME

$SPLUNK_HOME/bin/splunk start
