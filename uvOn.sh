#!/bin/bash

# quickhack script enhancement for UV lamp which tries
# to enhance the percentage value equally during one hour

# 20 blocks per hour each 3 minutes

if [ $# -ne 2 ]; then
echo Usage $0 [percent 5,10, ... 100] [block 1..20 ]
echo returns 1 if UV lamp is on during this time block and 0 if not
exit 0
fi

# parameter
percent=$1
block=$2

# constants
sumBlocks=20

# parameter check
if [ $percent -lt 0 ] || [ $percent -gt 100 ] || [ $block -lt 1 ] || [ $block -gt $sumBlocks ]
then
echo Parameter error: percent := { 0..100 }, block := { 1..20 }
exit 1
fi

if [ 0 -ne $(( $percent % 5 )) ]; then
echo Parameter error: percent has to be multiple of 5
exit 1
fi

# on 100 percent no calculations necessary
if [ $percent -eq 100 ]; then
echo 1
exit 0
fi

# on 0 percent no calculation is cecessary
if [ $percent -eq 0 ]; then
echo 0
exit 0
fi

blocksOn=$(( $percent / 5 ))
blocksOff=$(( $sumBlocks - $blocksOn ))


if [ $percent -le 50 ]; then
periode=$(( $sumBlocks / $blocksOn ))
invert=0
else
periode=$(( $sumBlocks / $blocksOff ))
invert=1
fi

erg=$(( $block % $periode ))
if [ $erg -eq 1 ]; then
retval=$((1 ^ invert))
else
retval=$((0 ^ invert))
fi

echo $retval
exit 0

