#!/bin/bash

file=$1

if [[ -e $file ]]; then
	wc -l $file
else
	echo "No File Provided"
fi


