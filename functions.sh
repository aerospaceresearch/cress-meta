#!/bin/bash

# functions used for cress.space

# include box configuration
. /home/pi/src/config.sh

# strings
strErrParameter='parameter error'

# temp file for switch off UV lamp unix timestamp
csFILE_UV=/tmp/uv.txt

# temp file which contains the action
csFILE_ACTION=/tmp/action.txt
csFILE_ACTION_JSON=/tmp/action.json
csFILE_ACTION_CSV=/tmp/action.csv

# gpios
if [ $csBOX -lt 3 ]; then
  GPIO_PUMP_IN=12
  GPIO_LED=4
  GPIO_AIR1=10
  GPIO_AIR2=11
fi

if [ $csBOX -eq 3 ]; then
  GPIO_PUMP_IN=5
  GPIO_WATER_SENSOR=16
  GPIO_LED=0
  GPIO_AIR1=0
  GPIO_AIR2=0
fi

# commands
CMD_GPIO=/usr/local/bin/gpio

# print a log mesage
PrintLogMessage() {
  echo $0 started at $(date)
}

SwitchAirOn() {
  if [ $GPIO_AIR1 -ne "0" ]; then
    $CMD_GPIO mode $GPIO_AIR1 out
    $CMD_GPIO write $GPIO_AIR1 1
  fi
  if [ $GPIO_AIR2 -ne "0" ]; then
    $CMD_GPIO mode $GPIO_AIR2 out
    $CMD_GPIO write $GPIO_AIR2 1
  fi
}

SwitchAirOff() {
  if [ $GPIO_AIR1 -ne "0" ]; then
    $CMD_GPIO write $GPIO_AIR1 0
  fi
  if [ $GPIO_AIR2 -ne "0" ]; then
    $CMD_GPIO write $GPIO_AIR2 0
  fi
}

SwitchPumpInputOn() {
  $CMD_GPIO mode $GPIO_PUMP_IN out
  $CMD_GPIO write $GPIO_PUMP_IN 1
}

SwitchPumpInputOff() {
  $CMD_GPIO mode $GPIO_PUMP_IN out
  $CMD_GPIO write $GPIO_PUMP_IN 0
}

SwitchLEDOn() {
  if [ $GPIO_LED -gt 0 ]; then
    $CMD_GPIO mode $GPIO_LED out
    $CMD_GPIO write $GPIO_LED 1
  fi
}

SwitchLEDOff() {
  if [ $GPIO_LED -gt 0 ]; then
    $CMD_GPIO write $GPIO_LED 0
  fi
}

SwitchWaterSensorOn() {
  $CMD_GPIO mode $GPIO_WATER_SENSOR out
  $CMD_GPIO write $GPIO_WATER_SENSOR 1
}

SwitchWaterSensorOff() {
  $CMD_GPIO write $GPIO_WATER_SENSOR 0
}

# PushSensorData DHT22 temperature inside °C 21.34
# 1: sensor_type: { photoresistor, FC28, photodiode, DHT22 }
# 2: value_type : { brightness, watermark, humidity, temperature }
# 3: position   : { inside, outside }
# 4: unit       : { °C, %, - }
# 5: value      : [DD.DD]
PushSensorData () {
if [ $# -ne 5 ]; then
  echo $strErrParameter
  return 1
else
  curl -d "box=$csBOX&sensor_type=$1&value_type=$2&position=$3&unit=$4&value=$5" https://cress.space/v1/sensor/ --header "Authorization: Token $csTOKEN"
fi
}

# PushSensorDHT22 21.34 34.56 inside
# 1: temperature: [DD.DD]
# 2: humidity   : [DD.DD]
# 3: position   : { inside, outside }
PushSensorDHT22() {
if [ $# -ne 3 ]; then
  echo $strErrParameter
  return 1
else
  temperature=$1
  humidity=$2
  position=$3

  PushSensorData DHT22 temperature $position °C $temperature
  PushSensorData DHT22 humidity $position % $humidity
fi
}

# Pulls action, parse JSON, output CSV file
PullAction() {
  curl https://cress.space/v1/action/$csBOX/ --header "Authorization: Token $csTOKEN" > $csFILE_ACTION_JSON
  $csROOT/parseAction.py $csFILE_ACTION_JSON > $csFILE_ACTION_CSV
}

# return percent amount of water
GetValuePercentWater() {
  water=$(awk '/Water/ { print $2 }' $csFILE_ACTION_CSV)
  echo $water
}

# return perent amount of UV
GetValuePercentUV() {
  uv=$(awk -F "\t" '/UV light/ { print $2 }' $csFILE_ACTION_CSV)
  echo $uv
}

# return amount of seconds from percent
# 1: percent : { 0 .. 100 }
GetValueSecondsWaterFromPercent() {
if [ $# -eq 1 ]; then
  water=$1
  if [ $water -lt 0 -o $water -gt 100 ]; then
    echo $strErrParameter
    return 1
  fi
  pumpSeconds=$(echo "$water * $csPumpSecondsFactor" | bc -l)
  echo $pumpSeconds
fi
}
