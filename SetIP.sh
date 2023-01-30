#!/bin/bash

echo "Enter IPv4 address: "
read ip_address

echo "Enter subnet mask: "
read subnet_mask

echo "Enter default gateway: "
read default_gateway

echo "Enter nameserver addresses, separated by a space: "
read -a nameservers

interface="$(ip route | grep default | awk '{print $5}')"

nameserver_str=""
for ns in "${nameservers[@]}"; do
  nameserver_str="$nameserver_str        - $ns\n"
done

cat << EOF | sudo tee /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      addresses: [$ip_address/$subnet_mask]
      gateway4: $default_gateway
      nameservers:
        addresses:
$nameserver_str
EOF

sudo netplan apply
