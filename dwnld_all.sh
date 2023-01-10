#!/bin/bash

listname="$(basename "$1")"
outdir="$(echo $1 | sed "s/$listname//")"
cd $outdir
pwd
cat $1 | while read line
do
	while [ ! "$(lsblk | grep /mnt)" ]
	do
		sleep 1;
	done
	ia download "$line" && echo "$line" >> ~/ia_done.txt || echo "$line" >> ~/ia_error.txt
done


