#!/bin/bash

# test script for uvOn.sh

echo -e % \\t block \\t onoff
for percent in $(seq 0 5 100)
	do for block in $(seq 20)
		do onoff=$(./uvOn.sh $percent $block)
		echo -e $percent \\t $block \\t $onoff
	done
done
