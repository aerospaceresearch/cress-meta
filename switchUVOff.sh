#!/bin/bash

# decice if UV lamp has to be switched off

. /home/pi/src/functions.sh

if [ -f $FILE_UV ]
then
	now=$(date +'%s')
	ts=$(cat $FILE_UV)

	if [ $ts -lt $now ]; then
		rm $FILE_UV
		SwitchUVOff
	fi
fi
