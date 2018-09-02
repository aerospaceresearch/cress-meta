#!/bin/bash

# include functions for cress.space
. /home/pi/src/functions.sh

# turn LED light on
SwitchLEDOn

sleep $1

# turn LED light off
SwitchLEDOff
