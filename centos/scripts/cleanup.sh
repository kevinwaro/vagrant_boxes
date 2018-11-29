#!/usr/bin/bash

# This script removes all the useless packages from the VM before to upload it in Vagrant

# Make a list of the packages to remove
read -r -d '' packages <<'EOF'
wpa_supplicant
sqlite
gcc
kernel-devel
kernel-headers
EOF

# If the  package is present then, delete it
for package in ${packages}; do
    if yum list installed "${package}" >> /dev/null 2>&1 ; then
        yum erase -y "${package}" 
    fi
done
