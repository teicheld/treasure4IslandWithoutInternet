#!/bin/bash

nameList=$1

if [ $1 ] && [ '--help' == $1 ]
then
	printf "usage: movieDownloader.sh titleList\n\n\n\n\n"
	echo I wrote this skript for wkipedia: https://en.wikipedia.org/wiki/List_of_children%27s_films
	echo append the corresponding year to each name to get better results
fi

while read line
do
	id=$(youtube-dl "ytsearch:$line" --get-id)
	url=$(echo https://www.youtube.com/watch?v=$id)
	duration=$(youtube-dl $url --get-duration)		#format: hh:mm:ss or mm:ss or ss
	array=($(echo $duration | sed 's/:/ /g'))				#count elements to convert time unit correctly to seconds
	elements=${#array[@]}
	case $elements in
	1)
		seconds=$(echo $duration | awk -F: '{ print $1 }')
		;;
	2)
		seconds=$(echo $duration | awk -F: '{ print ($1 * 60) + $2 }')
		;;
	3)
		seconds=$(echo $duration | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
		;;
	*)
		echo unreachable code
		;;

	esac

	if [ 2000 -lt $seconds ]
	then 
		youtube-dl $url -f worst
	else
		echo $line not found on youtube. Maybe try a search archive.org or thepiratebay.party 
	fi

		
		
done
