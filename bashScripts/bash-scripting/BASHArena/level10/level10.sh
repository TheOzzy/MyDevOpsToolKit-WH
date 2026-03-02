#!/bin/bash

dir_name="Arena_Boss"

mkdir -p $dir_name && cd $dir_name && touch file1.txt file2.txt file3.txt file4.txt file5.txt

cd ..

for file in "$dir_name"/*.txt; do
    {
        LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w 20 | head
        echo " Line : 1 - Hello "
        echo " Line : 2 - victory "
        echo " Line : 3 - Hello "
        echo " Line : 4 - Everybody "
        echo " Line : 5 - Else "
    } >> "$file"
done

echo "Lines created in files"

cd $dir_name && ls -lS

mkdir -p "Victory_archive"

for file in *.txt; do
    if grep -q "victory" "$file"; then
        echo "Found victory in $file, moving..."
        mv "$file" "Victory_archive/"
    fi
done	

echo "Files containing victory has been moved"
