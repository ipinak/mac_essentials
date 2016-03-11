#!/bin/bash

function usage() {
    echo "usage: ./mac_spoofer.sh <interface>"
}

if [ "$1" == "help" ]; then
    usage
    exit 1
elif [ ! $# -eq 1 ]; then
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

function run() {
    save_mac_addr
    mk_mac_addr

    sudo ifconfig ${IF} ether ${MAC}
}

run
OLD_MAC=$(ifconfig ${IF} | grep ether | sed 's/[^\t]ether\ //')

while [ $OLD_MAC != $MAC ]
do
    run
    OLD_MAC=$(ifconfig ${IF} | grep ether | sed 's/[^\t]ether\ //')
done

