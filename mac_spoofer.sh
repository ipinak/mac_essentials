#!/bin/bash
# This script is intended to be used for spoofing mac addresses of NICs. The
# way this is done is through `ifconfig`. Also, it's important to say that
# this script can run as a startup script.

# Handle inputs
IF=$1
TIMES=0


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

    ifconfig ${IF} ether ${MAC}
    OLD_MAC=$(ifconfig ${IF} | grep ether | sed 's/[^\t]ether\ //')
}

run

while [ $OLD_MAC != $MAC ]
do
    ((TIMES++))
    run

    if [ $TIMES -eq 3 ];
    then
        echo "Oooops..."
        exit -1
    fi
done
