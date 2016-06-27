# Scripts for the analysis

Images gathered by https://cress.space/ are analysed with image processing and results plotted.

## egi.py

Compute the green coverage in the images. Currently an automatic threshold is used and later the invalid images (without green in them) deselected at plot time by setting `threshmin`.

    egi.py -T *.jpeg > cycle_x.csv


## greenplot.R

You can set these variables and then source the script to plot:

	threshmin=15 # range [0-255], not [%] as in plot
	csvfilename="path/to/cycle_x.csv"
	plottitle="Cress green coverage analysis"
	source("greenplot.R")

