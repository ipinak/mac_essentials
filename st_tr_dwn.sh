#!/bin/bash

if [ "$1" == "help" ]; then
    echo "usage: ./st_tr_dwn.sh"
    exit 1
fi

PREFS=${HOME}/Library/Preferences


# See what has been tracked so far.
printf "Do you want to see what's been tracked (y/n)? "
read c
if [ $c == "y" ]; then
    echo "See what you've downloaded so far..."
    sqlite3 ${PREFS}/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineAgentName, LSQuarantineDataURLString, date(LSQuarantineTimeStamp + 978307200, "unixepoch") as downloadedDate from LSQuarantineEvent order by LSQuarantineTimeStamp' | sort | grep '|' --color
fi


printf "Do you want to delete them (y/n)? "
read c
if [ $c == "y" ]; then
    # Delete everything
    echo "Delete everything..."
    sqlite3 ${PREFS}/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
    sqlite3 ${PREFS}/com.apple.LaunchServices.QuarantineEventsV* 'vacuum'
fi

# To stop this from happening, either use automator and schedule
# a delete script or delete the file and create a symlink to /dev/null.
