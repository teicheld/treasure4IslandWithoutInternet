#!/bin/bash
mkdir -p /tmp/iaAudioDownloadOneFormatOnly/
parallel -u -j 30 '
	ia metadata --formats "{}" > /tmp/iaAudioDownloadOneFormatOnly/{}
	if [ "$(grep "64Kbps MP3 ZIP" /tmp/iaAudioDownloadOneFormatOnly/{})" ];
	then
		ia download --format="64Kbps MP3 ZIP" "{}"
	elif [ "$(grep "VBR ZIP" /tmp/iaAudioDownloadOneFormatOnly/{})" ];
	then
		ia download --format="VBR ZIP" "{}"

	elif [ "$(grep "64Kbps MP3" /tmp/iaAudioDownloadOneFormatOnly/{})" ];
	then
		ia download --format="64Kbps MP3" "{}"

	elif [ "$(grep "VBR MP3" /tmp/iaAudioDownloadOneFormatOnly/{})" ];
	then
		ia download --format="VBR MP3" "{}"

	fi
	'
