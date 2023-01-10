#!/bin/bash

loadingBarI=0
loadingBarDirection=1
function loadingBar {
	if [ $loadingBarI -gt 100 ]; then loadingBarDirection=-1; fi 
	if [ $loadingBarI -eq 45 ] && [ $loadingBarDirection -eq 1 ]; then printf $sum; let loadingBarI+=$(printf $sum | wc -c); fi 
	if [ $loadingBarI -lt 0 ]; then loadingBarDirection=1; fi 
	if [ $loadingBarDirection -eq 1 ]; then printf '.'; let loadingBarI++; fi
	if [ $loadingBarDirection -eq -1 ]; then printf '\b'; let loadingBarI--; fi
}

sum=0;
while read line; do 
	size=$(du "$line" | cut -f1)
	let sum+=size
	loadingBar
done
echo $sum
