#!/bin/bash -x

# todo quickhack, enhancements: move to functions.sh / oneshot.sh

PushSensorData() {
temperature=$1
humidity=$2
position=$3

curl -d "box=1&sensor_type=DHT22&value_type=temperature&position=$position&unit=°C&value=$temperature" https://cress.space/v1/sensor/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'
curl -d "box=1&sensor_type=DHT22&value_type=humidity&position=$position&unit=%&value=$humidity" https://cress.space/v1/sensor/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'

}
export -f PushSensorData


sudo /home/pi/lol_dht22/./loldht 7  | `awk '/Humidity/ { print "PushSensorData "$7 " " $3 " inside" }' `
sudo /home/pi/lol_dht22/./loldht 2  | `awk '/Humidity/ { print "PushSensorData "$7 " " $3 " outside" }' `

