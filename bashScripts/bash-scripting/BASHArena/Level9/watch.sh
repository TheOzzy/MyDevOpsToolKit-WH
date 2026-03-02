#!/bin/bash


fswatch -x -i . 0.1 /home/vboxuser/MyDevOpsToolKit-WH/scripts/scripts/Level9 | while read -r event 
do
	echo "Dectected $event"
done




