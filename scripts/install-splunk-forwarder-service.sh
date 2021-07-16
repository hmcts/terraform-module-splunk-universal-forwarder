#!/bin/bash
set -e

DOWNLOAD_URL="https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.2.0&product=universalforwarder&filename=splunkforwarder-8.2.0-e053ef3c985f-Linux-x86_64.tgz&wget=true"
INSTALL_FILE="splunkforwarder-8.2.0-e053ef3c985f-Linux-x86_64.tgz"
INSTALL_LOCATION="/opt"
UF_USERNAME=$1
UF_PASSWORD=$2
DEPLOYMENT_SERVER_URI="splunk-cm-prod-vm00.platform.hmcts.net:9997"
FORWARD_SERVER_URI="splunk-lm-prod-vm00.platform.hmcts.net:9997"

export SPLUNK_HOME="$INSTALL_LOCATION/splunkforwarder"

# Install splunk forwarder
curl --retry 3 -# -L -o $INSTALL_FILE $DOWNLOAD_URL
tar xvzf $INSTALL_FILE -C $INSTALL_LOCATION
rm -rf $INSTALL_FILE

# Start splunk forwarder
$SPLUNK_HOME/bin/splunk start --accept-license --no-prompt

# Set server name
$SPLUNK_HOME/bin/splunk set servername $hostname

# Set deployment server
$SPLUNK_HOME/bin/splunk set deploy-poll $DEPLOYMENT_SERVER_URI

# Set forward-server
$SPLUNK_HOME/bin/splunk add forward-server $FORWARD_SERVER_URI

# Create splunk admin user
{
cat <<EOF
[user-info]
USERNAME = $UF_USERNAME
HASHED_PASSWORD = $($SPLUNK_HOME/bin/splunk hash-passwd $UF_PASSWORD)
EOF
} > $SPLUNK_HOME/etc/system/local/user-seed.conf

$SPLUNK_HOME/bin/splunk restart

# Create boot-start systemd user
adduser --system --group splunk
chown -R splunk:splunk $SPLUNK_HOME


# Create boot-start systemd service
$SPLUNK_HOME/bin/splunk stop
sleep 10
$SPLUNK_HOME/bin/splunk enable boot-start -systemd-managed 1 -user splunk -group splunk
chown -R splunk:splunk $SPLUNK_HOME

$SPLUNK_HOME/bin/splunk start