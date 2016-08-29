#!/bin/bash

BATTINFO=`acpi -b`
while true; do
    if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` < 00:15:00 ]] ; then
        i3-nagbar -m "BATTERY LOW: $BATTINFO" -t warning
    fi
    sleep 1m
done

