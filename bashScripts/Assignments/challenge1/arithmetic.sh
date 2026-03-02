#!/bin/bash

echo -e "Welcome to the Basic Arithmetic Calculator \n"
echo -e "Calulates basic arithmetic operations (addition, subtraction, multiplication, division). \n"
echo "Please enter your first number"
read One
echo "Now enter your second number"
read Two

ADD=$(($One + $Two))
SUB=$(($One - $Two))
MUL=$(($One * $Two))
DIV=$(($One / $Two))

echo "

Here are all four operations 

[1 Addition] Total =  $ADD
[2 Subtraction] Total = $SUB
[3 Multiplication] Total = $MUL
[4 Division] Total = $DIV

"

