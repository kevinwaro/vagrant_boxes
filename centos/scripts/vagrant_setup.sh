#!/bin/bash

# This script sets up the requirements for building a Vagrant box with VirtualBox

# Load default Vagrant public key
yum install -y wget gcc kernel-devel kernel-headers bzip2 tar
mkdir -p /home/vagrant/.ssh 
chmod 700 /home/vagrant/.ssh/ 
/bin/sh -c "cd /home/vagrant/.ssh && wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys"
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant

# Install Virtual Box guest additions
mount -o loop,ro /var/tmp/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
rm /var/tmp/VBoxGuestAdditions.iso
