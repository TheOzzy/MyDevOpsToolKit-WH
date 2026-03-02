#!/bin/bash

the_sum(){
	local sum1=0
	local sum2=0
	local symbol=""
	printf "Welcome to Calculate Script"
	printf "\nPlease enter your first number"
	read sum1
	printf "\nNow your second number"
	read sum2

	printf "\nHere are their answers
	 \nTheir Sum (+) $(($sum1 + $sum2))
	 \nTheir Difference (-) $(($sum1 - $sum2))
	 \nTheir Product (*) - $(($sum1 * $sum2))
	 \nTheir Division (/) - $(($sum1 / $sum2))
	 \nEND"
}

the_sum
