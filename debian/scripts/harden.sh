#! /usr/bin/env bash

# This script will increase (a bit) the security of the VM

# We set some variables in sysctl related to network settings
cat << _EOF_ >> /etc/sysctl.conf

# IPV4
# Disable forwarding between interfaces
net.ipv4.ip_forward = 0
# Enable reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
# Don't sent ICMP redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
# Reject source routing packets
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
# Don't accept ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
# Log martian packets
net.ipv4.conf.all.log_martians = 1
# RFC 1337
net.ipv4.tcp_rfc1337 = 1
# Ignore non conform answers
net.ipv4.icmp_ignore_bogus_error_responses = 1
# Increase port range
net.ipv4.ip_local_port_range = 32768 65535
# Use SYN cookies
net.ipv4.tcp_syncookies = 1
# IPV6
# Disable router solicatations
net.ipv6.conf.all.router_solicitations = 0
net.ipv6.conf.default.router_solicitations = 0
# Don't accept router preference by "router advertisements"
net.ipv6.conf.all.accept_ra_rtr_pref = 0
net.ipv6.conf.default.accept_ra_rtr_pref = 0
# No prefix auto configuration by "router advertisements"
net.ipv6.conf.all.accept_ra_pinfo = 0
net.ipv6.conf.default.accept_ra_pinfo = 0
# No learning of the default router by "router advertisements"
net.ipv6.conf.all.accept_ra_defrtr = 0
net.ipv6.conf.default.accept_ra_defrtr = 0
# No auto configuration of the address by "router advertisements"
net.ipv6.conf.all.autoconf = 0
net.ipv6.conf.default.autoconf = 0
# Don't accept ICMP redirects
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
# Reject source routing packets
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
# Max amount of autoconf addresses by interface
net.ipv6.conf.all.max_addresses = 1
net.ipv6.conf.default.max_addresses = 1

_EOF_

# We set some variables in sysctl related to kernel settings
cat << _EOF_ >> /etc/sysctl.conf
# KERNEL
# Disable SysRq key
kernel.sysrq = 0
# No core dump from setuid programs
fs.suid_dumpable = 0
# Enable ASLR
kernel.randomize_va_space = 2
# Forbid memory allocation in low addresses
vm.mmap_min_addr = 65536
# Increase scope of choice for PID values
kernel.pid_max = 65536
# Obfuscate kernel memory addresses
kernel.kptr_restrict = 1
# Prevent unpriviledged users to access dmesg(8)
kernel.dmesg_restrict = 1
# Restict usage of perf subsystem
kernel.perf_event_paranoid = 2
kernel.perf_event_max_sample_rate = 1
kernel.perf_cpu_time_max_percent = 1

_EOF_

/sbin/sysctl -p

# Add netfilter-persistent and set IPTables rules
apt-get install -y netfilter-persistent
mkdir -p /etc/iptables
main_interface=$(ip a s | grep ^2 | awk '{ print $2 }' | tr -d ':')

cat << _EOF_ >> /etc/iptables/rules.v4
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT DROP [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp --icmp-type echo-request -j ACCEPT
-A INPUT -m state --state INVALID -j DROP
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -i ${main_interface} -m comment --comment "STANDARD SERVICES ACCESS"
-A INPUT -i ${main_interface} -p udp -m multiport --sport 53,123 -j ACCEPT
-A INPUT -i ${main_interface} -p tcp -m multiport --dport 22,80,443 --syn -m state --state NEW -j ACCEPT
-A INPUT -i ${main_interface} -m comment --comment "FILTER_INPUT END_MARKER"
-A OUTPUT -o lo -j ACCEPT
-A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
-A OUTPUT -m state --state INVALID -j DROP
-A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -m comment --comment "STANDARD SERVICES ACCESS"
-A OUTPUT -p tcp -m multiport --dport 22,25,43,80,443 --syn -m state --state NEW -j ACCEPT
-A OUTPUT -p udp -m multiport --dport 123,53 -j ACCEPT
-A OUTPUT -m comment --comment "FILTER_OUTPUT END_MARKER"
COMMIT

_EOF_

systemctl enable netfilter-persistent.service
systemctl restart netfilter-persistent.service
