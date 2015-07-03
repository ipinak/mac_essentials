#!/bin/bash

function usage() {
    echo "usage: ./mac_spoofer.sh <interface>"
}

if [ "$1" == "help" ]; then
    usage
    exit 1
fi

if [ ! $# -eq 1 ]; then
    usage
    exit -1
fi

IF=$1

function save_mac_addr() {
    ifconfig ${IF} | grep "ether:*" | sed "s/ether/\ /" >> ~/.macs
}

function mk_mac_addr() {
    # Generate 6 part MAC addr
    MAC=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
}

save_mac_addr
mk_mac_addr

echo "Your new MAC: " ${MAC}
sudo ifconfig ${IF} ether ${MAC}
