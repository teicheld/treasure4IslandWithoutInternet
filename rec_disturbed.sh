#!/bin/bash

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
		-o|--out)
			out="$2"
			shift
			shift
			;;
		-f|--frequency)
			frequency="$2"
			shift
			shift
			;;
		*)   
			echo "usage: 
				-f|--frequency)
				frequency to multiply with"
			exit
	esac
done

if [ ! "$frequency" ]; then
	frequency=500
fi
if [ ! "$out" ]; then
	out=disturbed_recording
fi

rec original.flac
sox -n -r 48000 /tmp/carrier.flac synth $(soxi -D original.flac) sine $frequency channels 2
sox -T original.flac /tmp/carrier.flac "unfiltered.flac"
sox "unfiltered.flac" "$out.flac" sinc $(($frequency+250))-$(($frequency-250))
ffmpeg -loglevel quiet -i "$out.flac" "$out.aac" && echo "created file $out.aac"
play "$out.flac" && wipe -f original.flac /tmp/carrier.flac unfiltered.flac && echo "created file $out.flac"



