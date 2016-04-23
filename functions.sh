#!/bin/bash

# functions used for cress.space


SwitchPumpOn() {
gpio mode 5 out
gpio write 5 1
}

SwitchPumpOff() {
gpio mode 5 out
gpio write 5 0
}

SwitchUVOn() {
sudo /home/pi/433Utils/RPi_utils/codesend 1361
}

SwitchUVOff() {
sudo /home/pi/433Utils/RPi_utils/codesend 1364
}

SwitchLEDOn() {
/usr/local/bin/gpio mode 4 out
/usr/local/bin/gpio write 4 1
}

SwitchLEDOff() {
/usr/local/bin/gpio write 4 0
}

PushSensorData() {
if [ $# -eq 3 ]; then
temperature=$1
humidity=$2
position=$3

curl -d "box=1&sensor_type=DHT22&value_type=temperature&position=$position&unit=°C&value=$temperature" https://cress.space/v1/sensor/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'
curl -d "box=1&sensor_type=DHT22&value_type=humidity&position=$position&unit=%&value=$humidity" https://cress.space/v1/sensor/ --header 'Authorization: Token 448a1661a5b8a79c9f40b2c1c491cb228baba63e'
fi
}
export -f PushSensorData


