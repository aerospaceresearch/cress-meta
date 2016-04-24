#!/bin/bash

# pull action and switch pump and UV light
# this script shall be called once a hour

. /home/pi/src/functions.sh

FILE_ACTION=/tmp/action.csv

# create csv file
PullAction > $FILE_ACTION

# parse file
water=$(awk '/Water/ { print $2 }' $FILE_ACTION)
uv=$(awk -F "\t" '/UV light/ { print $2 }' $FILE_ACTION)

# calculate pump on duration
pumpSeconds=$(echo "$water * 0.1" | bc -l)

# switch pump
SwitchPumpInputOn
sleep $pumpSeconds
SwitchPumpInputOff

# calculate UV off timestamp
secondsOff=$(echo "$uv * 3600 / 100" | bc -l)
date +'%s' --date="$secondsOff seconds" > $FILE_UV

# switch UV lamp on, yes we ignore 0% here but 
# script switchUVOff.sh shall handle this
SwitchUVOn

