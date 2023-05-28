#!/bin/bash

################### dependencies ###########
#for i in exiftool ffmpeg; do
#	[ ! -f /usr/bin/$i ] && sudo apt install $i 
#done
##########################################

defaultFPS=20
defaultCRF=34
defaultWIDTH=200
defaultAudioBitrate=8
if [ ! "$1" ]; then cat << EOF 
usage:    reduce_video -i|--input file [--fps fps] [-a|--audio-bitrate audioBitrate] [--crf crf] [--width width]
defaults: reduce_video filepath         $defaultFPS          $defaultAudioBitrate	$defaultCRF            $defaultWIDTH
EOF
exit; fi
while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--input|--input-file)
      file="$2"
      shift # past argument
      shift # past value
      ;;
    -f|--fps)
      fps="$2"
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
if [ 300 -lt $width_get ]
then
	ffmpeg -i "$file" -r $fps -vf scale=$width_set:-2 -vcodec libx265 -crf $CRF -c:a libopus -ac 1 -ar 16000 -b:a ${audioBitrate}K -vbr constrained "${basepath}_reduced.${ext}" 2>/dev/null
	[ -f "${basepath}_reduced.${ext}" ] && rm "$file" || echo couldnt reduce the quality of file "${basepath}_reduced.${ext}"
#else
#	echo width $width_get of "file "$file" is not bigger then 300. But i bet it have a higher framerate than 1 per seconds. Lets ditch the rest:)"
#	ffmpeg -i "$file" -r $fps "${basepath}_reduced.${ext}"
#	[ -f "${basepath}_reduced.${ext}" ] && rm -v "$file" || echo couldnt reduce the quality of file "${basepath}_reduced.${ext}"
fi
