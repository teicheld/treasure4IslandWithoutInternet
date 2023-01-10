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
if [ ! "$1" ] || [ $(printf "$1" | tail -c 1) != 'M' ]; then 
	echo "usage: find -type f foo | limitSize.sh maxSizeM       #('M' must be the suffix)"
	echo "like                      limitSize.sh 500M"
	echo "optional:                 limitSize.sh 500M [status=progress] > outputFile"
	exit
fi
max=$(printf $1 | head -c -1); max=$(($max * 1000))
while read line; do 
	size=$(du -L "$line" | cut -f1)
	if [ $(($sum + $size)) -lt $max ]
	then
		let sum+=size
		echo $line
		if [ "$2" ] && [ "$2" == 'status=progress' ]; then loadingBar >&2; fi
	#else
	#	echo sum=$sum
	#	break
	fi
done
echo sum=$sum
