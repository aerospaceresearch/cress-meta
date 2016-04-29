#!/bin/bash

# include functions for cress.space
. /home/pi/src/functions.sh

# include box confg  
. /home/pi/src/config.sh

# global variables
imagesfolder=/home/pi/images
timestamp="$(date +"%s")"
curdir=/home/pi/src
filename=$imagesfolder/$timestamp.jpeg


# turn UV light off
SwitchUVOff

# turn LED light on
SwitchLEDOn

# take picture
fswebcam --no-banner --rotate 180 -r 1280x720 $filename

# turn LED light off
SwitchLEDOff

# make post request picture
curl -s -F "box=$csBOX" -F "image=@$filename" https://cress.space/v1/photo/ --header "Authorization: Token $csTOKEN"

# push DHT22 sensor data
sudo /home/pi/lol_dht22/./loldht 7  | $(awk '/Humidity/ { print "PushSensorData "$7 " " $3 " inside"  }')
sudo /home/pi/lol_dht22/./loldht 2  | $(awk '/Humidity/ { print "PushSensorData "$7 " " $3 " outside" }')

# decide if UV lamp has to be switched on again
if [ -f /tmp/uv.txt ]
then
	SwitchUVOn
fi

