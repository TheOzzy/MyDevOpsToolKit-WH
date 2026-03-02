#!/bin/bash

Knight="Knight.txt"

if [[ -f $Knight ]]; then
	mv $Knight ./Archive
	echo "Knight Exists"
else
	echo "Knight does not exist"
fi


