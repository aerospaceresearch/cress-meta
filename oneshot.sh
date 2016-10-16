#!/bin/bash

# oneshot.sh
# this script handles image processing and data acquisition
# it shall be called by cron continously

# include functions for cress.space
. /home/pi/src/functions.sh

# global variables
TIMESTAMP="$(date +"%s")"
FILE_CAPTURE=$csIMAGES/$TIMESTAMP.jpeg
SENSORS_TMP=/tmp/sensors.txt
SENSORS_TTY=/dev/ttyACM0

# print log message
PrintLogMessage

# turn LED light on
SwitchLEDOn

# take picture
#fswebcam --no-banner --rotate 180 -r 1280x720 $FILE_CAPTURE
raspistill -rot $csROTATE_CAMERA -o $FILE_CAPTURE

# turn LED light off
SwitchLEDOff

# make post request picture
curl -s -F "box=$csBOX" -F "image=@$FILE_CAPTURE" https://cress.space/v1/photo/ --header "Authorization: Token $csTOKEN"

# push DHT22 sensor data
sudo /home/pi/lol_dht22/loldht $csPin_DHT_inside  | $(awk '/Humidity/ { print "PushSensorDHT22 "$7 " " $3 " inside"  }')
sudo /home/pi/lol_dht22/loldht $csPin_DHT_outside  | $(awk '/Humidity/ { print "PushSensorDHT22 "$7 " " $3 " outside" }')

if [ $csBOX -lt 3 ]; then
  # push other sensor data
  stty -F $SENSORS_TTY 9600
  head -n 4 $SENSORS_TTY > $SENSORS_TMP
fi
if [ $csBOX -gt 3 ]; then
  SwitchWaterSensorOn
  python /home/pi/src/adcdata.py > $SENSORS_TMP
  SwitchWaterSensorOff
fi

$(awk -F' = ' '/Photoresistor/ { print "PushSensorData photoresistor brightness inside - " $2 ; exit } ' $SENSORS_TMP)
$(awk -F' = ' '/Watermark/     { print "PushSensorData FC28          watermark  inside - " $2 ; exit } ' $SENSORS_TMP)
if [ $csBOX -eq 1 ]; then
  $(awk -F' = ' '/Photodiode/    { print "PushSensorData photodiode    brightness inside - " $2 ; exit } ' $SENSORS_TMP)
fi

# always enable Air (for now)
SwitchAirOn

