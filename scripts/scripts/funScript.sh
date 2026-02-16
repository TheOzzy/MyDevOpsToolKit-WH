#!/bin/bash

hello_world(){
	echo "Hello World!"

	local name="$1"
	echo "Hello, $name!"
}

hello_world "Omar"

