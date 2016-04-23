#!/bin/bash

# functions used


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

