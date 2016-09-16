#!/bin/bash
# -- ----------------------------------------------------------------------- --
# -- Install the bigboards fabric.
# -- ----------------------------------------------------------------------- --

# -- make sure this script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# -- read the hex name
echo "Enter the name of the hex:"
read HEX_NAME

# -- read the hex sequence
echo "Enter the sequence of the hex (you get it from us):"
read HEX_SEQ

# -- read the node sequence
echo "Enter the sequence of this node:"
read NODE_SEQ

RANGE="172.17.$HEX_SEQ"
MASK="255.255.255.0"

echo "Install the dependencies"
apt-get install -y python-pip nodejs nodejs-legacy npm node-colors vim

echo "Install the aws commandline tools"
pip install awscli

echo "Write the hostname (/etc/hostname)"
echo "${HEX_NAME}-n${NODE_SEQ}" > /etc/hostname

echo "Write the hosts file (/etc/hosts)"
cat <<<EOF > /etc/hosts
127.0.0.1 localhost

${RANGE}.${NODE_SEQ} ${HEX_NAME}-n${NODE_SEQ}
EOF

echo "Write the network configuration (/etc/network/interfaces)"
cat <<<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

# Internal network interface
auto eth0
iface eth0 inet static
    address ${RANGE}.${NODE_SEQ}
    netmask ${MASK}

# External network interface
auto eth1
iface eth1 inet dhcp
	pre-up ip link add name eth1 link eth0 type macvlan

EOF

echo "Write the network DHCP configuration (/etc/dhcp/dhclient.conf)"
cat <<<EOF > /etc/dhcp/dhclient.conf
# Configuration file for /sbin/dhclient, which is included in Debian's
#	dhcp3-client package.
#
# This file has been modified to send the hostname including the domain name.

option rfc3442-classless-static-routes code 121 = array of unsigned integer 8;

send host-name "${HEX_NAME}-n${NODE_SEQ}";
request subnet-mask, broadcast-address, time-offset, routers,
	domain-name, domain-name-servers, domain-search, host-name,
	dhcp6.name-servers, dhcp6.domain-search,
	netbios-name-servers, netbios-scope, interface-mtu,
	rfc3442-classless-static-routes, ntp-servers,
	dhcp6.fqdn, dhcp6.sntp-servers;
EOF