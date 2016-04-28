#!/bin/bash

. /home/pi/src/functions.sh

if [ -f $FILE_UV ]; then

now=$(date +'%s')
ts=$(cat $FILE_UV)

if [ $ts -lt $now ]; then
	rm $FILE_UV
	SwitchUVOff
	SwitchUVOff
	SwitchUVOff
	SwitchUVOff
	SwitchUVOff
	SwitchUVOff
fi
fi
