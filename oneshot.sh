#!/bin/sh -x

host=10.42.27.111
port=3000
postfile="api/photo"
imagesfolder=/home/pi/images

timestamp="$(date +"%s")"

filename=$imagesfolder/$timestamp.jpeg

SwitchOn() {
sudo /home/pi/433Utils/RPi_utils/codesend 1361
}

SwitchOff() {
sudo /home/pi/433Utils/RPi_utils/codesend 1364
}

# turn light on
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
SwitchOn
sleep 1

# take picture
fswebcam --no-banner --rotate 180 -r 1280x720 $filename


# turn light off
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff
SwitchOff

# read DHT22 sensor A
sudo /home/pi/lol_dht22/./loldht 7 | awk '/Humidity/ { print "Inside { Hum: " $3 ", Temp: " $7 " }" }'

# read DHT22 sensor B
sudo /home/pi/lol_dht22/./loldht 2 | awk '/Humidity/ { print "Outside { Hum: " $3 ", Temp: " $7 " }" }'

# make post request
curl -F "box=1" -F "image=@$filename" https://cress.space/v1/photo/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'


