#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo -e "Welcome to Backup Script for Text Files"
echo -e "A script that backs up all .txt files from one directory to another \n"

echo "Please enter the path to the directory - E.G. /my/path/is/here"
read path

if [[ -d $path ]]; then
	BACKUP_DIR="backup_$TIMESTAMP"

       mkdir $BACKUP_DIR
       cp "$path"/*.log "$BACKUP_DIR/"

       FILE_COUNT=$(ls -1 "$BACKUP_DIR" | wc -l)

       echo "Backup completed.
       
       There are a total - $FILE_COUNT files inside - $BACKUP_DIR"
       ls -lh "$BACKUP_DIR"
else
	echo "Directory does not exist"
fi

