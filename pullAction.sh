#!/bin/bash

# pull action and switch pump and UV light
# this script shall be called once a hour

# include functions for cress.space
. /home/pi/src/functions.sh

# print log message
PrintLogMessage


# create csv file
PullAction

# parse file
water=$(GetValuePercentWater)

# calculate pump on duration
pumpSeconds=$(GetValueSecondsWaterFromPercent $water)

# switch pump
SwitchPumpInputOn
sleep $pumpSeconds
SwitchPumpInputOff


