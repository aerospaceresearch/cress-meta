#!/usr/bin/env bats

# testing uvOn.sh

executable=./uvOn.sh
paramError='Parameter error: percent := { 0..100 }, block := { 1..20 }'

@test "$executable without arguments" {
	run $executable
	[ "$status" -eq 0 ]
}

@test "$executable parameter 'percent' not nultiple of 5 " {
	run $executable 4 1
	[ "$status" -eq 1 ]
	[ "$output" == 'Parameter error: percent has to be multiple of 5' ] 
}

@test "$executable parameter 'percent' < 0 " {
	run $executable -10 1
	[ "$status" -eq 1 ]
	[ "$output" == "$paramError" ]
}

@test "$executable parameter 'percent' > 100 " {
	run $executable 101 1
	[ "$status" -eq 1 ]
	[ "$output" == "$paramError" ]
}

@test "$executable parameter 'block' < 1 " {
	run $executable 10 0
	[ "$status" -eq 1 ]
	[ "$output" == "$paramError" ]
}
@test "$executable parameter 'block' > 20 " {
	run $executable 10 21
	[ "$status" -eq 1 ]
	[ "$output" == "$paramError" ]
}

@test "$executable 5 1 := 1" {
	run $executable 5 1
	[ "$status" -eq 0 ]
	[ "$output" -eq 1 ]
}

@test "$executable 5 2 := 0" {
	run $executable 5 2
	[ "$status" -eq 0 ]
	[ "$output" -eq 0 ]
}

