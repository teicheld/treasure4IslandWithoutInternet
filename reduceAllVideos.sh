#!/bin/bash

################### dependencies ###########
[ "$(whoami | grep u0)" ] && isArm=1 || isX86=1
if [ $isArm ]; then
	for i in exiftool ffmpeg; do
		[ ! -f /usr/bin/$i ] && apt install $i 
	done
elif [ $isX86 ]; then
	for i in exiftool ffmpeg; do
		[ ! -f /usr/bin/$i ] && sudo apt install $i 
	done
else
	echo "unreachable code"
	exit
fi
##########################################

defaultCRF=34
defaultWIDTH=200
defaultAudioBitrate=8
if [ ! "$1" ]; then cat << EOF 
usage:    reduce_video -i|--input file [-a|--audio-bitrate audioBitrate] [--crf crf] [--width width]
defaults: reduce_video filepath         $defaultAudioBitrate		  $defaultCRF     $defaultWIDTH
EOF
exit; fi
while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--input|--input-file)
      file="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--audio-bitrate)
      audioBitrate="$2"
      shift # past argument
      shift # past value
      ;;
    -c|--crf)
      CRF="$2"
      shift # past argument
      shift # past value
      ;;
    -w|--width)
      width_set="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      echo unknown option \"$1\"
      exit
      ;;
  esac
done
if [ ! "$file" ]; then echo must specify an inputFile; exit; fi
if [ ! $fps ]; then fps=$defaultFPS; fi
if [ ! $CRF ]; then CRF=$defaultCRF; fi
if [ ! $audioBitrate ]; then audioBitrate=$defaultAudioBitrate; fi
if [ ! $width_set ]; then width_set=$defaultWIDTH; fi

basepath=$(echo "$file" | rev | cut -d '.' -f 2- | rev)
ext=$(echo "$file" | rev | cut -d '.' -f 1 | rev)
width_get=$(exiftool "$file" | grep "Source Image Width" | cut -d ":" -f 2 | cut -d ' ' -f 2)
statusFile=~/media/video/.converting
isInStatusFile="$(grep "$file" "$statusFile")"
if [ -f "$statusFile" ] && [ ! "$isInStatusFile" ]
then
	echo "$file" >> "$statusFile"
	ffmpeg -i "$file" -vf scale=$width_set:-2 -vcodec libx265 -crf $CRF -c:a libopus -ac 1 -ar 16000 -b:a ${audioBitrate}K -vbr constrained "${basepath}_reduced.${ext}" 2>/dev/null
	[ -f "${basepath}_reduced.${ext}" ] && rm "$file" || echo couldnt reduce the quality of file "${basepath}_reduced.${ext}"
	sed -i "/$file/d" "$statusFile"
elif [ "$isInStatusFile" ]
	printf "$file
	echo has an entry in the statusFile $statusFile"
else
	echo "unreachable code"
fi
