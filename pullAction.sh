#!/bin/bash -x

. functions.sh

PullAction > /tmp/action.csv

water=$(awk '/Water/ { print $2 }' /tmp/action.csv)
uv=$(awk -F "\t" '/UV light/ { print $2 }' /tmp/action.csv)


pumpSeconds=$(echo "$water * 0.1" | bc -l)

SwitchPumpInputOn
sleep $pumpSeconds
SwitchPumpInputOff

secondsOff=$(echo "$uv * 3600 / 100" | bc -l)
date +'%s' --date="$secondsOff seconds" > $FILE_UV


