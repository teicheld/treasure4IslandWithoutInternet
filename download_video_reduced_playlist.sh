#!/bin/bash

function install_dependencies {
	for tool in parallel yt-dlp; do [ ! -f /usr/bin/$tool ] && sudo apt install -y $tool; done
	[ ! -f /usr/bin/aria2c ] && sudo apt install -y aria2
}
install_dependencies

#yt-dlp --download-archive ~/.downloaded --external-downloader aria2c --external-downloader-args "--console-log-level=error --split=16 --min-split-size=5M --max-connection-per-server=16" --no-playlist -f worst -i -o "./media/video/%(uploader)s/%(title)s.%(ext)s" --exec 'reduce_video.sh -i {}' $1;
yt-dlp --yes-playlist --get-id "$1" | parallel -u -j 8 download_video_reduced.sh {}
