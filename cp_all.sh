#!/bin/bash

pi='pi@192.168.1.72'

max=$(cat "$1" | wc -l)
for i in $(seq 1 $max)
do
	while [ ! "$(ssh $pi 'lsblk' | grep '/mnt')" ]
	do
		echo not_mounted..remounting...
		hdd=$(ssh $pi lsblk | grep sd. | head -c 3)
		while [ "$(echo $hdd | head -c 2)" != "sd" ]
		do
			echo hdd not detected by os. cannot mount
			hdd=$(ssh $pi lsblk | grep sd. | head -c 3)
			sleep 1
		done
		ssh $pi "sudo mount /dev/${hdd}1 /mnt"
	done
	echo $i
	file="$(cat $1 | awk NR==$i)"
	#echo src="/$(echo "$file" \| sed "s/ /\\\ /g; s/(/\\\(/g; s/)/\\\)/g; s/\[/\\\[/g; s/]/\\\]/g; s/\'/\\\'/g")"
	src="/$(echo "$file" | sed "s/ /\\\ /g; s/(/\\\(/g; s/)/\\\)/g; s/\[/\\\[/g; s/]/\\\]/g; s/'/\\\'/g; s/&/\\\&/g")"
	#echo src = "$src"
	dest="$file"
	scp -l 4000 "$pi:$src" "$dest" && echo "$file" >> ok || echo "$file" >> error.log
done
