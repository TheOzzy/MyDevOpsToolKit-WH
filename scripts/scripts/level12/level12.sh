#!/bin/bash


CONFIG_PATH="/etc/adduser.conf"


while IFS='=' read -r KEY VALUE; do
	echo "KEY =  $KEY"
	echo "VALUE =  $VALUE"
done < $CONFIG_PATH
