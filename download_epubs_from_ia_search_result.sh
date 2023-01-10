#!/bin/bash

while [[ $# -gt 0 ]]
do
	argument="$1"
	case $argument in
		-u|--url)
			url="$2"
			shift
			shift
			;;
		-p|--pages)
			pages="$2"
			shift
			shift
			;;
		*)
			echo "unknown argument: $2"
			shift
			;;
	esac
done

if [ ! $pages ] || [ ! $url ]
then
	echo "download_epubs_from_ia_search_result.sh -u|--url <url> -p|--pages <amount>"
	exit
fi

if [ "$(echo "$url" | grep '&page=')" ]
then
	url="$(echo "$url" | sed 's/&page=.*//')"
fi

for i in $(seq 1 $pages)
do
	curl "$url&page=$i" | grep ' <a href="/details/' | grep -o '/.*title' | sed 's/" title//' | while read line
	do 
		name=$(echo $line | cut -d '/' -f 3)
		echo $line/$name.epub
	done
done
