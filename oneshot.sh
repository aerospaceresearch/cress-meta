#!/bin/bash

# include functions for cress.space
. functions.sh

# global variables
host=10.42.27.111
port=3000
imagesfolder=/home/pi/images

timestamp="$(date +"%s")"
curdir=/home/pi/src

filename=$imagesfolder/$timestamp.jpeg


# turn UV light off
for i in $(seq 10); do SwitchUVOff; done

# turn LED light on
SwitchLEDOn

#sleep 1

# take picture
fswebcam --no-banner --rotate 180 -r 1280x720 $filename

# turn LED light off
SwitchLEDOff

# make post request picture
curl -s -F "box=1" -F "image=@$filename" https://cress.space/v1/photo/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'

# push DHT22 sensor data
sudo /home/pi/lol_dht22/./loldht 7  | `awk '/Humidity/ { print "PushSensorData "$7 " " $3 " inside" }' `
sudo /home/pi/lol_dht22/./loldht 2  | `awk '/Humidity/ { print "PushSensorData "$7 " " $3 " outside" }' `

# TODO turn UV light on or off?
for i in $(seq 10); do SwitchUVOn; done

