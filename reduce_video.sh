#!/bin/bash

################### dependencies ###########
[ "$(whoami | grep u0)" ] && isArm=1 || isX86=1
if [ $isArm ]; then
	for i in ffmpeg; do
		[ ! -f /usr/bin/$i ] && apt install $i 
	done
elif [ $isX86 ]; then
	for i in ffmpeg; do
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

basepath=$(echo "$file" | rev | cut -d '.' -f 2- | rev)
ext=$(echo "$file" | rev | cut -d '.' -f 1 | rev)
statusFile=~/media/video/.converting
touch $statusFile && isInStatusFile="$(grep "$file" "$statusFile")"

if [ ! "$file" ]; then echo must specify an inputFile; exit; fi
if [ "$(echo $file | grep reduced)" ] || [ "$isInStatusFile" ]; then echo "skipping file $file"; exit; fi
if [ ! $fps ]; then fps=$defaultFPS; fi
if [ ! $CRF ]; then CRF=$defaultCRF; fi
if [ ! $audioBitrate ]; then audioBitrate=$defaultAudioBitrate; fi
if [ ! $width_set ]; then width_set=$defaultWIDTH; fi

echo "$file" >> "$statusFile"

ffmpeg -i "$file" -vf scale=$width_set:-2 -vcodec libx265 -crf $CRF -c:a libopus -ac 1 -ar 16000 -b:a ${audioBitrate}K -vbr constrained "${basepath}_reduced.${ext}" #2>/dev/null
[ -f "${basepath}_reduced.${ext}" ] && rm "$file" || echo couldnt reduce the quality of file "${basepath}_reduced.${ext}"

sed -i "\@$file@d" "$statusFile"
