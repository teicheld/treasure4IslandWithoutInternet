#!/bin/bash

function install_dependencies {
	for tool in parallel yt-dlp; do [ ! -f /usr/bin/$tool ] && sudo apt install -y $tool; done
	[ ! -f /usr/bin/aria2c ] && sudo apt install -y aria2
}
install_dependencies

#yt-dlp --yes-playlist --get-id "$1" | parallel -u -j 8 yt-dlp --external-downloader aria2c --external-downloader-args "'--split=8 --min-split-size=5M --max-connection-per-server=8'" --no-playlist -f worst -i -o '"$HOME/media/video/%(playlist_title)s/%(title)s.%(ext)s"' --exec 'reduce_video.sh -i \{\}'  {} 
yt-dlp --yes-playlist --get-id "$1" | parallel -u -j 8  download_video.sh {} 
