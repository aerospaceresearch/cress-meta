#!/bin/bash

# include functions for cress.space
. /home/pi/src/functions.sh

# global variables
imagesfolder=/home/pi/images
timestamp="$(date +"%s")"
curdir=/home/pi/src
filename=$imagesfolder/$timestamp.jpeg
TMP_SENSORS=/tmp/sensors.txt


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
sudo /home/pi/lol_dht22/./loldht 7  | $(awk '/Humidity/ { print "PushSensorDHT22 "$7 " " $3 " inside"  }')
sudo /home/pi/lol_dht22/./loldht 2  | $(awk '/Humidity/ { print "PushSensorDHT22 "$7 " " $3 " outside" }')

# push other sensor data
head -n 20 /dev/ttyACM0 > $TMP_SENSORS
$(awk -F' = ' '/Photoresistor/ { print "PushSensorData photoresistor brightness inside - " $2 ; exit } ' $TMP_SENSORS)
$(awk -F' = ' '/Photodiode/    { print "PushSensorData photodiode    brightness inside - " $2 ; exit } ' $TMP_SENSORS)
$(awk -F' = ' '/Watermark/     { print "PushSensorData FC28          watermark  inside - " $2 ; exit } ' $TMP_SENSORS)


# decide if UV lamp has to be switched on again
if [ -f /tmp/uv.txt ]
then
	SwitchUVOn
fi

# always enable Air (for now)
SwitchAirOn

