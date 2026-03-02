#!/bin/bash

if [ -d "Arena" ]; then
	echo "Arena folder already exists"
else
	mkdir Arena
	touch Arena/{warrior,mage,archer}.txt
	ls -l Arena
	echo "The Arena and it's players have been created!"
fi


