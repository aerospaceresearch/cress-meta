#!/bin/bash

# iterate over cycles, unpack with unzip
datadirs=""
for dname in box{1..9}_cycle{1..100}
do
	if [ -d "$dname" ] ; then
		echo "dir $dname exists"
		datadirs="$datadirs $dname"
		continue
	else
		if [ -f "${dname}.zip" ] ; then
			echo "unzipping ${dname}.zip"
			unzip -d "${dname}" "${dname}.zip"
		fi
	fi
done

# iterate over 
for cycdir in $datadirs
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

