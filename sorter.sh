#!/bin/bash

find -type f -exec mv "{}" . -v \;
find -empty -type d -delete
mkdir -p sorter sorter/images sorter/images/organicFinal sorter/images/organic2reduce sorter/images/documentFinal sorter/images/document2reduce
mkdir -p sorter/videos sorter/videos/2reduce sorter/videos/final
mkdir -p sorter/pdf

if [ ! -f /usr/bin/feh ]
then
	echo wanna install feh
        sudo apt install feh
fi
if [ ! -f /usr/bin/convert ]
then
	echo wanna install imagemagick
        sudo apt install imagemagick
fi
function installRequirementsVideoConvert {
	if [ ! -f /usr/bin/ffmpeg ]
	then
		echo wanna install ffmpeg
		sudo apt install ffmpeg
	fi
	if [ ! -f /usr/bin/exiftool ]
	then
		echo wanna install exiftool
		sudo apt install -y exiftool
	fi
}

counter=0
total=$(ls *jpg *jpeg *png *JPG | wc -l)
for i in ls *jpg *jpeg *png *JPG
do
	let counter++
	echo "File: $i"
	feh --fullscreen "$i"
	read -p "[a] organicKeep [s] organic2reduce [d] documentKeep [f] document2reduce [g] remove [h] rename ...your choise:   	" answer; 
	newName="$i"
	if [ $answer == "h" ]; 
	then
		read -p "new name ...	" newFilename; 
		fileExtension=$(echo "$i" | rev | cut -d '.' -f 1 | rev)
		newName="${newFilename}.$fileExtension"
		read -p "[a] organicKeep [s] organic2reduce [d] documentKeep [f] document2reduce ...your choise:   	" answer; 
	fi
	if [ $answer == "a" ]; 
	then 
		mv --verbose "$i" "./sorter/images/organicFinal/$newName"; 
	elif [ $answer == "s" ]; 
	then 
		mv --verbose "$i" "./sorter/images/organic2reduce/$newName"; 
	elif [ $answer == "d" ]; 
	then 
		mv --verbose "$i" "./sorter/images/documentFinal/$newName"; 
	elif [ $answer == "f" ]; 
	then
		mv --verbose "$i" "./sorter/images/document2reduce/$newName"
	elif [ $answer == "g" ]; 
	then 
		rm --verbose "$i"
	fi
	echo "${counter}/$total"
done


	for i in ls *mp4 *avi *3gp *webm *mpeg
	do
		echo "File: $i"
		cvlc --no-video-title-show "$i"
		read -p "[a] keep [s] reduce [g] remove [h] rename ...your choise:   	" answer; 
		newName="$i"
		if [ $answer == "h" ]; 
		then
			read -p "new name ...	" newFilename; 
			fileExtension=$(echo "$i" | rev | cut -d '.' -f 1 | rev)
			newName="${newFilename}.$fileExtension"
			echo newName = $newName
			read -p "[a] keep [s] reduce [g] remove ...your choise:   	" answer; 
		fi
		if [ $answer == "a" ]; 
		then 
			mv --verbose "$i" ./sorter/videos/final/$newName; 
		elif [ $answer == "s" ]; 
		then 
			mv --verbose "$i" ./sorter/videos/2reduce/$newName; 
		elif [ $answer == "g" ]; 
		then 
			rm --verbose "$i"; 
		fi
	done

for i in ls *pdf
do
	echo "File: $i"
	qpdfview "$i"
	read -p "[a] keep [s] convert2jpg [g] remove [h] rename...your choise:   	" answer; 
	newName="$i"
	if [ $answer == "h" ]; 
	then
		read -p "new name ...	" newFilename; 
		fileExtension=$(echo "$i" | rev | cut -d '.' -f 1 | rev)
		newName="${newFilename}.$fileExtension"
		read -p "[a] keep [s] convert2jpg ...your choise:   	" answer; 
	fi
	if [ $answer == "a" ]; 
	then 
		mv --verbose "$i" ./sorter/pdf/$newName; 
	elif [ $answer == "s" ]; 
	then 
		convert -verbose "$i" "${newName}.jpg"; 
	elif [ $answer == "g" ]; 
	then 
		rm --verbose "$i"; 
	fi
done
	
for i in sorter/images/*
do 
	if [ $(du "$i" | cut -f1) == 4 ] 
	then 
		echo "removing empty directories:.." 
		rm -r --verbose "$i"  
	fi 
done
for i in sorter/videos/*
do 
	if [ $(du "$i" | cut -f1) == 4 ] 
	then 
		rm -r --verbose "$i"  
	fi 
done
for i in sorter/*
do 
	if [ "$(du "$i" | cut -f1)" == 4 ] 
	then 
		rm -r --verbose "$i"  
	fi 
done


read -p "reduce quality of all images in the folders *2reduce now? [y]/[n]:" answer; 

if [ $answer == "y" ]; 
then 
	for i in sorter/images/organic2reduce/*
	do
		size=$(identify "$i" | cut -d ' ' -f 4 | cut -d 'x' -f 1)
		if [ 400 -lt $size ]
		then		
			mogrify -verbose -resize 400 -strip -quality 80 "$i"
		else
			echo "file "$i" with the size of $size is not bigger then 400."
		fi
	done
	for i in sorter/images/document2reduce/*
	do
		size=$(identify "$i" | cut -d ' ' -f 4 | cut -d 'x' -f 1)
		if [ 400 -lt $size ]
		then		
			mogrify -verbose -resize 400 -strip -quality 80 "$i"
		else
			echo "file "$i" with the size of $size is not bigger then 400."
		fi
	done
fi


read -p "reduce quality of all images in the folder organicFinal (which you have choosen for organicKeep) to 800? [y]/[n]:" answer; 

if [ $answer == "y" ]; 
then 
	for i in sorter/images/organicFinal/*
	do
		size=$(identify "$i" | cut -d ' ' -f 4 | cut -d 'x' -f 1)
		if [ 800 -lt $size ]
		then		
			mogrify -verbose -resize 800 -strip -quality 80 "$i"
		else
			echo "file "$i" with the size of $size is not bigger then 800."
		fi
	done
	for i in sorter/images/documentFinal/*
	do
		size=$(identify "$i" | cut -d ' ' -f 4 | cut -d 'x' -f 1)
		if [ 800 -lt $size ]
		then		
			mogrify -verbose -resize 800 -strip -quality 80 "$i"
		else
			echo "file "$i" with the size of $size is not bigger then 800."
		fi
	done
fi
if [ -d sorter/videos/2reduce/ ]
then
	read -p "reduce quality of all videos in the folder 2reduce to 250:2? [y]/[n]:" answer; 
	if [ $answer == "y" ]; 
	then
		installRequirementsVideoConvert
		mkdir -p "sorter/videos/done"
		cd "sorter/videos/2reduce/"
		for i in *
		do
			width=$(exiftool "$i" | grep "Source Image Width" | cut -d ":" -f 2 | cut -d ' ' -f 2) 
			if [ 176 -lt $width ]
			then		
				echo executing ffmpeg -i "$i" -r 2 -vf scale=176:-2 "../../../sorter/videos/done/$i"
				ffmpeg -i "$i" -r 2 -vf scale=176:-2 "../../../sorter/videos/done/$i"
				if [ -f "../../../sorter/videos/done/$i" ]
				then
					rm -v "$i"
				else
					echo couldnt reduce the quality of file $i
				fi
			else
				echo "file "$i" with the width of $width is not bigger then 176. But i bet it have a higher framerate than 2 per seconds. Lets ditch the rest:)"
				echo executing ffmpeg -i "$i" -r 2 "../../../sorter/videos/done/$i"
				ffmpeg -i "$i" -r 2 "../../../sorter/videos/done/$i"
				if [ -f "../../../sorter/videos/done/$i" ]
				then
					rm -v "$i"
				else
					echo couldnt reduce the quality of file $i
				fi
			fi
		done
		cd ../../../
	fi
fi

if [ -d sorter/videos/final/ ] 
then
	read -p "reduce quality of all videos in the folder final to 400:-2? [y]/[n]:" answer; 
	if [ $answer == "y" ]; 
	then 
		installRequirementsVideoConvert
		mkdir -p "sorter/videos/done"
		cd sorter/videos/final/
		for i in *
		do
			width=$(exiftool "$i" | grep "Source Image Width" | cut -d ":" -f 2 | cut -d ' ' -f 2)
			if [ 400 -lt $width ]
			then		
				echo "executing ffmpeg -i "$i" -r 7 -vf scale=400:-2 "../../../sorter/videos/done/$i""
				ffmpeg -i "$i" -r 7 -vf scale=400:-2 "../../../sorter/videos/done/$i"
				if [ -f "../../../sorter/videos/done/$i" ]
				then
					rm -v "$i"
				else
					echo couldnt reduce the quality of file $i
				fi
			else
				echo width $width of "file "$i" is not bigger then 400. But i bet it have a higher framerate than 7 per seconds. Lets ditch the rest:)"
				echo executing ffmpeg -i "$i" -r 7 "../../../sorter/videos/done/$i"
				ffmpeg -i "$i" -r 7 "../../../sorter/videos/done/$i"
				if [ -f "../../../sorter/videos/done/$i" ]
				then
					rm -v "$i"
				else
					echo couldnt reduce the quality of file $i
				fi
			fi
		done
		cd ../../../
	fi
fi

mkdir sorter/images/organic/ sorter/images/documents/
mv sorter/images/organicFinal/* sorter/images/organic/
mv sorter/images/organic2reduce/* sorter/images/organic/
mv sorter/images/documentFinal/* sorter/images/documents/
mv sorter/images/document2reduce/* sorter/images/documents/
mv sorter/videos/done/* sorter/videos/

find -empty -type d -delete

if [ -d sorter/videos/2reduce/ ] ||  [ -d sorter/videos/final/ ] 
then
	echo the video conversion didnt happend. 
fi
