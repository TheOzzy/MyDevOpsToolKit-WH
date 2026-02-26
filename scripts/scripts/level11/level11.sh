#!/bin/bash

TARGET="./folder"
LIMIT=20

if [ ! -d "$TARGET" ]; then
    echo "Error: Directory $TARGET does not exist."
    exit 1
fi

echo "--- Disk Usage Report for: $TARGET ---"

# 1. Total size of the directory

TOTAL_SIZE=$(du -sk "$TARGET" | awk '{print $1}')

echo "Total Size: $TOTAL_SIZE KB"

# 2. Compare Total Size to Limit

if [ "$TOTAL_SIZE" -ge "$LIMIT" ]; then
	echo "Directory space is limited, please free-up size"
fi


