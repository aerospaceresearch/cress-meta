#!/usr/bin/env bats

# testing functions.sh
. functions.sh

@test "SwitchAirOn()" {
	declare -f SwitchAirOn
}
