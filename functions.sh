#!/bin/bash

# functions used for cress.space

# include box configuration
. /home/pi/src/config.sh

# temp file for switch off UV lamp unix timestamp
FILE_UV=/tmp/uv.txt

GPIO_PUMP_IN=12
GPIO_PUMP_OUT=13
GPIO_LED=4


SwitchPumpInputOn() {
gpio mode $GPIO_PUMP_IN out
gpio write $GPIO_PUMP_IN 1
}

SwitchPumpInputOff() {
gpio mode $GPIO_PUMP_IN out
gpio write $GPIO_PUMP_IN 0
}

SwitchPumpOutputOn() {
gpio mode $GPIO_PUMP_OUT out
gpio write $GPIO_PUMP_OUT 1
}

SwitchPumpOutputOff() {
gpio mode $GPIO_PUMP_OUT out
gpio write $GPIO_PUMP_OUT 0
}

SwitchUVOn() {
sudo /home/pi/433Utils/RPi_utils/codesend 1361
}

SwitchUVOff() {
sudo /home/pi/433Utils/RPi_utils/codesend 1364
}

SwitchLEDOn() {
/usr/local/bin/gpio mode $GPIO_LED out
/usr/local/bin/gpio write $GPIO_LED 1
}

SwitchLEDOff() {
/usr/local/bin/gpio write $GPIO_LED 0
}

# 1: temperature: [DD.DD]
# 2: humidity   : [DD.DD]
# 3: position   : { inside, outside }
PushSensorData() {
if [ $# -eq 3 ]; then
temperature=$1
humidity=$2
position=$3

curl -d "box=$csBOX&sensor_type=DHT22&value_type=temperature&position=$position&unit=°C&value=$temperature" https://cress.space/v1/sensor/ --header "Authorization: Token $csTOKEN"
curl -d "box=$csBOX&sensor_type=DHT22&value_type=humidity&position=$position&unit=%&value=$humidity" https://cress.space/v1/sensor/ --header "Authorization: Token $csTOKEN"
fi
}
export -f PushSensorData

PullAction() {
tmpAction=/tmp/action.txt
curl https://cress.space/v1/action/1/ --header "Authorization: Token $csTOKEN" > $tmpAction
/home/pi/src/parseAction.py $tmpAction
}
