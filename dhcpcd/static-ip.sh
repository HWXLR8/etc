#!/bin/bash

INTERFACE="eno1"
STATIC_IP="192.168.1.3/24"
ROUTER="192.168.1.1"

cat <<EOF >> /etc/dhcpcd.conf

interface $INTERFACE
static ip_address=$STATIC_IP
static routers=$ROUTER
EOF

echo "Restarting dhcpcd..."
rc-service dhcpcd restart
