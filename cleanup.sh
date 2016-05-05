#!/bin/sh

# cleanup.sh
# shall be run i.e. once a day in order to perform cleanup tasks

# delete files older than 2 days
find ../images/*.jpeg -mtime +2 -type f -delete

