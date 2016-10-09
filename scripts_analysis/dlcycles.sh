#!/bin/bash

for bx in {1..5}
do 
for cy in {1..200}
do
	wget -c "http://shit.machen.click/box${bx}_cycle${cy}.zip"
done
done
