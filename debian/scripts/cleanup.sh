#!/usr/bin/env bash

# This script removes all the useless packages from the VM before to upload it in Vagrant

# Make a list of the packages to remove
read -r -d '' packages <<'EOF'
bluetooth
bluez
wireless-regdb
wireless-tools
wpasupplicant
laptop-detect
avahi-autoipd
libavahi-client3
libavahi-common3
libavahi-common-data
nfs-common
libnfsidmap2
rpcbind
powertop
EOF

# If the  package is present then, delete it
for package in ${packages}; do
    if dpkg -l "${package}" >> /dev/null 2>&1 ; then
        apt-get purge -y "${package}" 
    fi
done

# Remove all the unused packages
apt-get autoremove -y 
