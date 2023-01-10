#!/bin/bash

function format {
	if [ $(printf $1 | tail -c 1) == '/' ]
	then
		printf $1 | head -c -1
	else
		printf $1
	fi
}

function createOverview {
		[ ! -d "$1"/overview/ ] && mkdir "$1"/overview/
		find "$sourcePath" >> "$1"/overview/allFiles.txt
		find "$sourcePath" -maxdepth 1 -type d >> "$1"/overview/baseDirs.txt
		tree "$sourcePath" >> "$1"/overview/tree.txt
		echo "$sourcePath" >> "$1"/overview/mainSourceDirs.txt
}

function createParentDirectories {
	parents="$(echo "${destination}/$sourcePath" | rev | cut -d '/' -f 2- | rev)" #the term 'parents' refers
	mkdir -vp "$parents"			#to the the 7z archive which is going to move into there
}

function compress {
	sourcePathPath="$(format "$sourcePath")"
	7z a -mx=9 "${destination}/${sourcePath}.7z" "${sourcePath}"
}

function markCompressed {
	mv -v "$sourcePath" "$(echo $sourcePath | head -c -1)"'(copied)'
}

destination="${@: -1}"

if [ $# -eq 1 ]; then echo "provide one or multiple source(s) to one destination as arguments"; exit; fi
for sourcePath in "$@"
do
	if [ "$sourcePath" != ${destination} ]
	then
		createParentDirectories
		compress
		createOverview "${destination}"
		markCompressed 
	fi
done

############## obsolete shit ############################
#sudo cp --archive --verbose --parents $sourcePath ${destination}
#cp -rvp $@
#ls -l --time-style=+%d/%m/%y $origin >> ${destination}/where_does_it_come_from.txt
#origin="$origin $sourcePath"
