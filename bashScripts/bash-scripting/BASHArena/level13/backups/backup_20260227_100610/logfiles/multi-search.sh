#!/bin/bash

echo "Please enter a word you'd like to find?"
read word

grep -r "$word" *.log

