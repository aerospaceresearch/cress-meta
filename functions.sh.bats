#!/usr/bin/env bats

# testing functions.sh
. /home/pi/src/functions.sh

@test "PrintLogMessage()" {
	declare -f PrintLogMessage
}

@test "SwitchAirOn()" {
	declare -f SwitchAirOn
}

@test "SwitchAirOff()" {
	declare -f SwitchAirOff
}

@test "SwitchPumpInputOn()" {
	declare -f SwitchPumpInputOn
}

@test "SwitchPumpInputOff()" {
	declare -f SwitchPumpInputOff
}

@test "SwitchPumpOutputOn()" {
	declare -f SwitchPumpOutputOn
}

@test "SwitchPumpOutputOff()" {
	declare -f SwitchPumpOutputOff
}

@test "SwitchUVOn()" {
	declare -f SwitchUVOn
}

@test "SwitchUVOff()" {
	declare -f SwitchUVOff
}

@test "SwitchLEDOn()" {
	declare -f SwitchLEDOn
}

@test "SwitchLEDOff()" {
	declare -f SwitchLEDOff
}

@test "PushSensorData()" {
	declare -f PushSensorData
}

@test "PushSensorData - not 5 parameter" {
	run PushSensorData 1 2 3 4
	[ "$status" -eq 1 ]
	[ "$output" == "parameter error" ]

	run PushSensorData 1 2 3 4 5 6
	[ "$status" -eq 1 ]
	[ "$output" == "parameter error" ]
}

@test "PushSensorDHT22()" {
	declare -f PushSensorDHT22
}

@test "PushSensorDHT22 - not 3 parameter" {
	run PushSensorDHT22 1 2
	[ "$status" -eq 1 ]
	[ "$output" == "parameter error" ]

	run PushSensorDHT22 1 2 3 4
	[ "$status" -eq 1 ]
	[ "$output" == "parameter error" ]
}

@test "PullAction()" {
	declare -f PullAction
}

@test "GetValuePercentWater()" {
	declare -f GetValuePercentWater
}

@test "GetValuePercentUV()" {
	declare -f GetValuePercentUV
}

@test "GetValueSecondsWaterFromPercent()" {
	declare -f GetValueSecondsWaterFromPercent
}

@test "GetValueSecondsWaterFromPercent parameter 'percent' < 0" {
	run GetValueSecondsWaterFromPercent -1
	[ "$status" -eq 1 ]
   [ "$output" == "parameter error" ]
}

@test "GetValueSecondsWaterFromPercent parameter 'percent' > 100" {
	run GetValueSecondsWaterFromPercent 101
	[ "$status" -eq 1 ]
   [ "$output" == "parameter error" ]
}

@test "GetValueSecondsWaterFromPercent: 0 10 50 100" {
	run GetValueSecondsWaterFromPercent 0
	[ "$status" -eq 0 ]
	[ "$output" -eq 0 ]

	run GetValueSecondsWaterFromPercent 10
	[ "$status" -eq 0 ]
	[ "$output" == ".10" ]

	run GetValueSecondsWaterFromPercent 50
	[ "$status" -eq 0 ]
	[ "$output" == ".50" ]

	run GetValueSecondsWaterFromPercent 100
	[ "$status" -eq 0 ]
	[ "$output" == "1.00" ]
}

