install
cdrom

lang en_US.UTF-8
keyboard us
timezone UTC

network --bootproto=dhcp
firewall --disabled

auth --enableshadow --passalgo=sha512 --kickstart
selinux --permissive
rootpw vagrant

unsupported_hardware

text
skipx

clearpart --all --initlabel
zerombr
bootloader --location=mbr
part /boot --size 512 --asprimary --fstype=ext4 --ondrive=sda
part pv.1 --size 1 --grow --fstype=ext4 --ondrive=sda
volgroup volume --pesize=8192 pv.1
logvol / --fstype ext4 --vgname volume --size=3072 --name=root
logvol /var --fstype ext4 --vgname volume --size=1 --grow --name=var
logvol swap --vgname volume --size=1024 --name=swap

firstboot --disabled
reboot

eula --agreed
services --enabled=NetworkManager,sshd

%packages --ignoremissing --excludedocs
@Core

# unnecessary firmware
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
%end

%post
yum update -y
chkconfig acpid off
chkconfig auditd off
chkconfig blk-availability off
chkconfig bluetooth off
chkconfig certmonger off
chkconfig cpuspeed off
chkconfig cups off
chkconfig haldaemon off
chkconfig ip6tables off
chkconfig lvm2-monitor off
chkconfig messagebus off
chkconfig mdmonitor off
chkconfig rpcbind off
chkconfig rpcgssd off
chkconfig rpcidmapd off
chkconfig yum-updateonboot off

# vagrant
groupadd vagrant -g 1001
useradd vagrant -g vagrant -G wheel -u 1001
echo "vagrant" | passwd --stdin vagrant

# sudo
yum install -y sudo
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

yum clean all
%end
