#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo -e "File Operation Script now running....."

mkdir bash_demo 

echo -e "Directory 'bash_demo' created \n"

cd bash_demo
touch demo.txt
echo "File 'demo.txt' created."
echo "this file was created by this BASH script on $TIMESTAMP" >> demo.txt

cat demo.txt

