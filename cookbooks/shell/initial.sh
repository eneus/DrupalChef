#!/bin/bash

VAGRANT_DIR="/vagrant"
DC_CHEF=$(echo "$1")
# Branding...
cat "$VAGRANT_DIR/cookbooks/shell/vdd.txt"

# Upgrade Chef.
echo "Updating Chef to $DC_CHEF version. This may take a few minutes..."

if [ -f /etc/lsb-release ]; then

    apt-get update &> /dev/null
    apt-get install build-essential ruby1.9.1-dev --no-upgrade --yes &> /dev/null
    gem install chef --version $DC_CHEF --no-rdoc --no-ri --conservative &> /dev/null
    
elif [ -f /etc/debian_version ]; then

    apt-get update &> /dev/null
    apt-get install build-essential ruby1.9.1-dev --no-upgrade --yes &> /dev/null
    gem install chef --version $DC_CHEF --no-rdoc --no-ri --conservative &> /dev/null
    
elif [ -f /etc/redhat-release ]; then

    yum check-update &> /dev/null
    yum install build-essential ruby1.9.1-dev --no-upgrade --yes &> /dev/null
    gem install chef --version $DC_CHEF --no-rdoc --no-ri --conservative &> /dev/null
    
else
    OS=$(uname -s)
    VER=$(uname -r)
fi