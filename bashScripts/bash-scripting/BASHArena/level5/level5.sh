#!/bin/bash


mkdir "Battlefield"
touch Battlefield/{knight,socerer,rogue}.txt

if [[ -e "Battlefield/knight.txt" ]]; then
	echo "The Knight exists, moving to Archive"
       mkdir -p "Archive"
        echo "Archive created"
	mv Battlefield/knight.txt Archive/
	echo "Knight moved to Archive"
 	echo -e "Process complete \n"

	echo -e "List of contents inside Battlefield \n"
	ls -la Battlefield

	echo -e "List of contents inside Archive \n"
	ls -la Archive
else
	echo "Please check if the knight exists first"
fi


