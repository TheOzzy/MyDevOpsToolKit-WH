#!/bin/bash

FILE="./hero.txt"

if [[ -f "$FILE" ]]; then
	echo "Hero Found!"
else
	echo "Hero Missing!"
fi



