#!/bin/bash
fileName=$(echo $1 | rev | cut -d "/" -f1 | rev)
file=$1
compTo=$2
if [ ! "$(find "$compTo" -name "$fileName")" ]
then
	echo $file >> notFound.txt
	echo
	echo missing: $fileName
else
	echo $file >> found.txt
	printf .
fi
