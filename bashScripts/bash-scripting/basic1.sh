#!/bin/bash

name=""
age=0

echo "What's your name?"
read name
echo "How old are you?"
read age

newAge=$age+10

greet(){
	echo"Hello $name, in 10 years you'll be $(($age + 10)) years old"
}


greet $name $newAge

