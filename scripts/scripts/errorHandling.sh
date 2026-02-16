#!/bin/bash

num1=10
num2=0

# 1. The Space-Sensitive Check
if [ "$num2" -eq 0 ]; then
    echo "Error: Division by zero is not allowed"
    exit 1
fi

# 2. The Calculation (only happens if num2 is NOT 0)
result=$(( num1 / num2 ))
echo "The result is: $result"
