echo searching items...
ia search "'$1' AND mediatype:(texts)" --sort="avg_rating desc" --itemlist | head -n 1000 > "$1".itemlist
wc -l "$1.itemlist"
[ $2 ] && numProcesses=$2 || numProcesses=50
echo searching for textOnlyBooks with $numProcesses processes, randomly delayed, 25s in average...
amount=$(cat "$1".itemlist | wc -l)

printf $amount > /tmp/amount
printf "$1" > /tmp/topic
printf "$(pwd)/$1.textOnly.itemlist" > /tmp/itemlistLocation
[ -f "$(pwd)/$1.textOnly.itemlist" ] && rm "$(pwd)/$1.textOnly.itemlist";


cat "$1".itemlist | parallel -u -j $numProcesses '
	sleep $((1 + RANDOM % 50))
	if [ $(ia metadata --formats {} | grep DjVuTXT) ]; then 
		echo {};
		i=$(cat "$(cat /tmp/itemlistLocation)" | wc -l)
		amount=$(cat /tmp/amount)
		echo $i/$amount >&2;
		printf $i > /tmp/i
	fi
	' | tee -a "$(cat /tmp/itemlistLocation)"
rm -v "$1".itemlist
wc -l "$(cat /tmp/itemlistLocation)"

## create download-script #######
outDir="$HOME/media/text/$1"
cat << EOF > download_"$1".sh
	#!/bin/bash
	topic="$(cat /tmp/topic)"
	mkdir -pv "$outDir"; cd "$outDir"; pwd; 
	cat "$(cat /tmp/itemlistLocation)" | parallel -u -j 50 'ia download {} --format="DjVuTXT"'
EOF
#################################
chmod +x "download_${1}.sh"
#printf "I created the startup script for you: \n$(cat "download_${1}.sh")\n\nlocatet at ./$(ls "download_${1}.sh").\nexecute it? [y/n]\n"
#read answer
#if [ $answer == 'y' ]; then 
	./"download_${1}.sh" && rm -v "$1.textOnly.itemlist"
#else
#	exit
#fi
#read -p "compress downloaded files? [y/n]?" answer
#if [ $answer == 'y' ]; then 
	7z a -mx=9 "${outDir}.7z" "$outDir" && rm -r "$outDir" && echo removed "$outDir" && rm -r "download_${1}.sh"
#else
#	exit
#fi
