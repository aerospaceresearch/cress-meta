#!/usr/bin/python

# usage: parseAction.py [file]
# parses the cress.space action from JSON format and 
# prints the data as a table to stdout

import sys
import json
import csv

from pprint import pprint

json_data=open(sys.argv[1]).read()

data = json.loads(json_data)

#pprint(data)

for row in data["action"]:
	print row["action_type"], "\t", row["decision"], "\t", row["start_time"]


