#!/bin/bash

function getPercent
{
	multiplicator=$(( 100 / $2 ))
	echo $(( $multiplicator * $1 ))%
}

if [ $1 ] && [ $1 == "--market" ] && [ $(echo $2 | head -c 2) == 'us' ]
then
	market=usd
else
	market=eur
fi
url="https://stackoverflow.com/jobs?c=$market&ms=Student&mxs=Junior"
urlPageN="$url&pg="
maxPages=$(curl --silent "$url" | grep -o 'page 1 of ..' | tail -c 3)
echo fetching data...
curl --silent "$url" | grep -o 'z-selected">..........................' | sed 's/^.*">//; s/<.*$//' >> list
for i in $(seq 2 $maxPages)
do 
	getPercent $i $maxPages
	curl --silent "${urlPageN}$i" | grep -o 'z-selected">..........................' | sed 's/^.*">//; s/<.*$//' >> list
done
echo

if [ -f result.txt ]; then rm result.txt; fi

all_uniq="$(sort list | uniq)"

for uniq in $all_uniq
do
	i=0
	for tec in $(cat list)
	do
		if [ "$tec" == "$uniq" ]
		then
			let i++
		fi
	done
	printf "$i:\t$uniq\n" >> result.txt
	printf "$i:\t$uniq\n"
done

sort -n result.txt
rm result.txt list

