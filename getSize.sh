sum=0;
if [ ! "$1" ] || [ $(printf "$1" | tail -c 1) != 'M' ]; then 
	echo "usage: find foo | getSize.sh maxSizeM       #('M' must be the suffix)"
	echo "like              getSize.sh 500M"
	exit
fi
max=$(printf $1 | head -c -1); max=$(($max * 1000))
while read line; do 
	if [ "$sum" -lt $max ]; then
		size=$(du "$line" | cut -f1)
		let sum+=size
		echo $line
	else
		echo sum=$sum
		break
	fi
done
