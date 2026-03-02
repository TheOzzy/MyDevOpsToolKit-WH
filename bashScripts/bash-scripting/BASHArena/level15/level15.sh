#!/bin/bash

echo -e "Select the Option by entering the number into the system \n"

echo -e "\n
[ 1 ] Check Disk Space \n
[ 2 ] Show the System Uptime \n
[ 3 ] List all Users on Machine \n
"

read input

case $input in
    1)
        echo -e "Checking disk space... \n"
        df -h
        ;;
    2)
        echo -e "System Uptime is: \n"
        uptime
        ;;
    3)
        echo -e "Listing users... \n"
        cut -d: -f1 /etc/passwd
        ;;
    *)
        echo "Invalid Option! Please pick 1, 2, or 3."
        ;;
esac


