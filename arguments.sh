#!/bin/bash

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
		-o|--output)
			output="$2"
			shift
			shift
			;;
		*)   
			echo "usage: [-o|--output] <output_dir>"
			exit
	esac
done

if [ ! "$output" ]
then
	outupt="./"
fi
