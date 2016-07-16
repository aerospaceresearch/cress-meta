#!/bin/bash

# iterate over cycles, unpacked with unzip -d cycleX cycleX.zip
for cycdir in cycle*/
do
	mkdir -p "$cycdir/speedseed/"
	pushd "$cycdir"
	echo "starting egi.py in ${cycdir}" 
	egi.py -T *.jpeg > "${cycdir}.csv"
	pushd "speedseed/"
	#                         -m 20 -M 81 -s 39 -S 255 -v 29 -V 236
	speedseed.py -p "$(pwd)/" -m 23 -M 75 -s 39 -S 255 -v 29 -V 236  -o -5  -n 5 -N 3 -d -g ../*.jpeg
	#speedseed.py -p "$(pwd)/" -m 23 -M 68 -s 39 -S 255 -v 29 -V 200  -o -5  -n 5 -N 3 -d -g ../*.jpeg
	echo "$(ls *.stackthresh.png| wc -l) *.stackthresh.png files"
	egi.py -t 128 -g 1 -b 0 -r 0 *.stackthresh.png > "${cycdir%/}_threshold_percent.csv"
	popd
	popd
done

# remove unnecessary files
find . -name '*.stackthresh.png.egi*' -o -name '*.postions.csv' -delete

