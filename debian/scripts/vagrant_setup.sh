#!/bin/bash

# This script sets up the requirements for building a Vagrant box with VirtualBox

# Install Virtual Box guest additions
apt-get install -y linux-headers-$(uname -r) build-essential dkms
mount -o loop,ro /var/tmp/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
rm /var/tmp/VBoxGuestAdditions.iso

# Add the vagrant user to sudoers
echo -e "\nvagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
