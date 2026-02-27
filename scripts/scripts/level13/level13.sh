#!/bin/bash

DIR="./backups"
SOURCE="/home/osman/Documents/Github/MyDevOpsToolKit-WH/scripts/scripts/logfiles"
TIME_STAMP=$(date +%Y%m%d_%H%M%S)
NEW_BACKUP="$DIR/backup_$TIME_STAMP"

cp -r "$SOURCE" "$NEW_BACKUP"

echo "Copy completed"

ls -dt "$DIR"/backup_* | tail -n +6 | xargs rm -rf




