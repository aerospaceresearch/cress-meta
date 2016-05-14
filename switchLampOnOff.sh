#!/bin/bash

# switch UV lamp on or off
# this script shall be called each 3 minutes

# include functions for cress.space
. /home/pi/src/functions.sh

# print log message
PrintLogMessage

uv=$(GetValuePercentUV)
minute=$(date +%M)

block=$(( $minute / 3 ))
if [ $block -eq 0 ]; then
	block=1
fi

OnOff=$($csROOT/uvOn.sh $uv $block)

#todo quickhack to avoid collision with oneshot.sh script
sleep 30

if [ $OnOff -eq 1 ]; then
	echo Block $block : On
	SwitchUVOn
else
	echo Block $block : Off
	SwitchUVOff
fi
