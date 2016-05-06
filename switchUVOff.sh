#!/bin/bash

# decice if UV lamp has to be switched off

# include functions for cress.space
. /home/pi/src/functions.sh

if [ -f $csFILE_UV ]
then
	now=$(date +'%s')
	ts=$(cat $csFILE_UV)

	if [ $ts -lt $now ]; then
		rm $csFILE_UV
		SwitchUVOff
	fi
fi
