#!/bin/bash

# functions used for cress.space

# include box configuration
. /home/pi/src/config.sh

# temp file for switch off UV lamp unix timestamp
csFILE_UV=/tmp/uv.txt
# temp file which contains the action
csFILE_ACTION=/tmp/action.txt

GPIO_PUMP_IN=12
GPIO_PUMP_OUT=13
GPIO_LED=4

GPIO_AIR1=10
GPIO_AIR2=11
CMD_GPIO=/usr/local/bin/gpio

SwitchAirOn() {
$CMD_GPIO mode $GPIO_AIR1 out
$CMD_GPIO write $GPIO_AIR1 1 
$CMD_GPIO mode $GPIO_AIR2 out
$CMD_GPIO write $GPIO_AIR2 1
}

SwitchAirOff() {
$CMD_GPIO write $GPIO_AIR1 0
$CMD_GPIO write $GPIO_AIR2 0
}

SwitchPumpInputOn() {
$CMD_GPIO mode $GPIO_PUMP_IN out
$CMD_GPIO write $GPIO_PUMP_IN 1
}

SwitchPumpInputOff() {
$CMD_GPIO mode $GPIO_PUMP_IN out
$CMD_GPIO write $GPIO_PUMP_IN 0
}

SwitchPumpOutputOn() {
$CMD_GPIO mode $GPIO_PUMP_OUT out
$CMD_GPIO write $GPIO_PUMP_OUT 1
}

SwitchPumpOutputOff() {
$CMD_GPIO mode $GPIO_PUMP_OUT out
$CMD_GPIO write $GPIO_PUMP_OUT 0
}

SwitchUVOn() {
for i in $(seq 10); do 
sudo /home/pi/433Utils/RPi_utils/codesend 1361
done
}

SwitchUVOff() {
for i in $(seq 10); do 
sudo /home/pi/433Utils/RPi_utils/codesend 1364
done
}

SwitchLEDOn() {
$CMD_GPIO mode $GPIO_LED out
$CMD_GPIO write $GPIO_LED 1
}

SwitchLEDOff() {
$CMD_GPIO write $GPIO_LED 0
}


# PushSensorData DHT22 temperature inside °C 21.34
# 1: sensor_type: { photoresistor, FC28, photodiode, DHT22 }
# 2: value_type : { brightness, watermark, humidity, temperature }
# 3: position   : { inside, outside }
# 4: unit       : { °C, %, - }
# 5: value      : [DD.DD]
PushSensorData () {
if [ $# -eq 5 ]; then
curl -d "box=$csBOX&sensor_type=$1&value_type=$2&position=$3&unit=$4&value=$5" https://cress.space/v1/sensor/ --header "Authorization: Token $csTOKEN"
fi
}

# PushSensorDHT22 21.34 34.56 inside
# 1: temperature: [DD.DD]
# 2: humidity   : [DD.DD]
# 3: position   : { inside, outside }
PushSensorDHT22() {
if [ $# -eq 3 ]; then
temperature=$1
humidity=$2
position=$3

PushSensorData DHT22 temperature $position °C $temperature
PushSensorData DHT22 humidity $position % $humidity

fi
}

PullAction() {
curl https://cress.space/v1/action/1/ --header "Authorization: Token $csTOKEN" > $csFILE_ACTION
$csROOT/parseAction.py $csFILE_ACTION
}
