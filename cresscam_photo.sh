#!/bin/bash

# this script captures photo and uploads it.
# it shall be called by cron continously

# NOT used for box photos. but for cresscam!!

# include box configuration
. /home/pi/src/config.sh

# global variables
TIMESTAMP="$(date +"%s")"
FILE_CAPTURE=$csIMAGES/$TIMESTAMP.jpg

# take picture
fswebcam --no-banner --rotate 180 -S 2 -r 1024x768 $FILE_CAPTURE

# make post request picture
curl -s -F "box=$csBOX" -F "photo=@$FILE_CAPTURE" https://cress.space/v1/photo/ --header "Authorization: Token $csTOKEN"

# send picture to analog tv
sudo pkill fbi
sudo fbi -a -1 --vt 1 -noverbose $FILE_CAPTURE >/dev/null 2>&1
