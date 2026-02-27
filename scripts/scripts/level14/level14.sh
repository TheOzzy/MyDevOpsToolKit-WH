#!/bin/bash

echo -e "Select the Option by entering the number into the system \n"

echo -e "\n
[ 1 ] Check Disk Space \n
[ 2 ] Show the System Uptime \n
[ 3 ] List all Users on Machine \n
"

read input

if [ $input == 1 ]; then
	echo -e "Total Disk Space on Machine : 50.128 MB \n"
elif [ $input == 2 ]; then
	echo -e "Current System Uptime : 02:14:54:02 \n"
elif [ $input == 3 ]; then
	echo -e "Here are all the Users on Machine : vboxuser \n"
else
	echo -e "Re-enter your selection number \n"
fi
