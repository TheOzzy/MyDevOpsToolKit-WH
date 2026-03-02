#!/bin/bash

count=0

while [[ $count -le 10 ]]
do
	echo "This is Line Number : $count"
	((count++))
done

