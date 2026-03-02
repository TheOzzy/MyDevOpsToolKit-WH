#!/bin/bash


echo -e "Welcome to File Checker - the script that checks if a file exists and displays its permission."

echo -e "Please enter the name of the file you wish to display content out \n"
read output

echo "$output has the following file permissions " 

if [[ -r $output ]]; then
	echo "The file is readable"
fi
if [[ -w $output ]]; then 
	echo "The file is writable"
fi
if [[ -x $output ]]; then
	echo "The file is executable"
fi 
