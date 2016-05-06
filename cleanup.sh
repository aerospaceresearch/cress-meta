#!/bin/sh

# cleanup.sh
# shall be run i.e. once a day in order to perform cleanup tasks

# include functions for cress.space
. /home/pi/src/functions.sh

# delete files older than 2 days
find $csIMAGES/*.jpeg -mtime +2 -type f -delete

