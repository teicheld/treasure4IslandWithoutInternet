if [ -d /tmp/list2audioBulk/ ]
then 
	rm -r /tmp/list2audioBulk/
fi
if [ -d playlists ]
then 
	rm -r playlists/
fi
mkdir -p /tmp/list2audioBulk/

if [ "$1" ] && [ -f "$1" ] && [ "$2" ] && [ -f "$2" ]
then
	searchTermList=$1
	whitelist=$2
elif [ "$1" ] && [ -f "$1" ] && [ ! "$2" ]
then
	searchTermList=$1
	whitelist=$1
elif [ "$1" ] && [ "$1" == "--help" ]
then
	echo usage: list2audioBulk.sh searchTermList whitelist
	echo whitelist = removes all playlists whitout one of the words. Newline-seperated
	exit
else
	if [ -f audioLinks.list ]; then
		rm audioLinks.list
	fi
	echo paste in here a list with searchterms and press ctrl+d twice if you are finished.
	while read line
	do
		echo $line >> audioLinks.list
	done
	searchTermList=audioLinks.list
	whitelist=$searchTermList
fi

#removing empty newlines
grep . $searchTermList > /tmp/foo; mv /tmp/foo $searchTermList
grep . $whitelist > /tmp/foo; mv /tmp/foo $whitelist

#convert names to playlisturls
countLines=$(cat $searchTermList | wc -l)
for i in $(seq 1 $countLines)
do 
	line=$(cat $searchTermList | awk NR==$i)
	line_converted=$(echo $line | sed 's/ /%20/g')
	line=$line_converted
	clear; 
	echo downloading youtube-page $i of $countLines with playlists containing the keyword $line 
	curl -s "https://www.youtube.com/results?search_query=${line}&sp=EgIQAw%253D%253D" | grep -o 'playlistId......................................' | sed s/playlistId\":\"// | sed s/\".*// | uniq >> /tmp/list2audioBulk/${searchTermList}.ids
done

echo merging the playlistIDs with the youtube-specific URL scheme. Saving them in the file /tmp/list2audioBulk/${searchTermList}.playlists.
while read line
do 
	echo "https://www.youtube.com/playlist?list=${line}" >> /tmp/list2audioBulk/${searchTermList}.playlists
done < /tmp/list2audioBulk/${searchTermList}.ids
rm /tmp/list2audioBulk/${searchTermList}.ids


####extracting titles of each video inside the playlists


#rm ${1}.videotitles
amountPlaylists=$(cat /tmp/list2audioBulk/${searchTermList}.playlists | wc -l)
for i in $(seq 1 $amountPlaylists )
do
	actualPlaylist=$(cat /tmp/list2audioBulk/${searchTermList}.playlists | awk NR==$i)
	####user output####
	clear
	echo extracting videotitles of file /tmp/list2audioBulk/${searchTermList}.playlists
	echo into file 
	echo /tmp/list2audioBulk/videotitles/${searchTermList}/${playlistID}.videotitles
	echo playlistnumber $i of $amountPlaylists
	##end user output##

	mkdir -p /tmp/list2audioBulk/videotitles/${searchTermList}
	playlistID=$(echo $actualPlaylist | sed 's/https:\/\/www.youtube.com\/playlist?list=//')
	videoTitlePattern='","width":336,"height":188}\]},"title":{"runs":\[{"text":"...................................................................................................................'
	removeVideoPostFix='s/"}\],".*//'
	removeVideoPreFix='s/","width":336,"height":188}\]},"title":{"runs":\[{"text":"//'
	curl --silent $actualPlaylist | grep -o $videoTitlePattern | sed $removeVideoPostFix | sed $removeVideoPreFix >> /tmp/list2audioBulk/videotitles/${searchTermList}/${playlistID}.videotitles
	
done

####################videotitlesSorter###############################

for playlist in /tmp/list2audioBulk/videotitles/${searchTermList}/*
do
	if $(grep --file $whitelist --quiet --ignore-case $playlist)
	then
		echo deleting all playlists without whitelisted keywords and moving the sorted results into the folders playlists
		match="$(grep --max-count=1 --file $whitelist -o --ignore-case $playlist)"
		#remove whitespaces (multi matches, or original multi word patterns)
		if [ 1 -lt $(echo $match | wc -w) ]; then match=$(echo $match | sed 's/ /_/g'); fi
		echo match=$match
		mkdir -p "playlists/${match,,}"
		mv $playlist "playlists/${match,,}/"
		clear
		if [ 15 -lt $(ls playlists/*/ | wc -l) ]
		then
			for folder in playlists/*/
			do 
				printf "%s %d\n" $folder $(ls $folder | wc -l)
			done
		else
			printf "%s %d\n" allFoundPlaylists $(find -type f -name "*videotitles" | wc -l)
		fi
	fi
done

#creating a list of playlistIDS
for topic in playlists/*/
do
	name=$(echo $topic | cut -d '/' -f2)
	IDlist=${topic}${name}.IDs
	if [ -f $IDlist ]; then rm $IDlist; fi
	for playlistID in $topic/*
	do
		echo $playlistID | rev | cut -d '/' -f1 | rev | sed s/.videotitles// >> $IDlist
	done

	while read line
	do 
		echo "https://www.youtube.com/playlist?list=${line}" >> ${topic}${name}.playlists
	done < $IDlist
	if [ -f $IDlist ]; then rm $IDlist; fi
done

mv $searchTermList /tmp/$searchTermList
resultFolder=$(echo $searchTermList | cut -d '.' -f1)
mkdir $resultFolder
mv /tmp/$searchTermList $resultFolder
mv playlists/ $resultFolder
