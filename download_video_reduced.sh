#!/bin/bash

[ ! -f /usr/bin/aria2c ] && sudo apt install aria2
yt-dlp --download-archive ~/.downloaded --external-downloader aria2c --external-downloader-args "--console-log-level=error --split=16 --min-split-size=5M --max-connection-per-server=16" --no-playlist -f worst -i -o "./media/video/%(playlist_title)s/%(title)s.%(ext)s" --exec 'reduce_video.sh -i {}' "$1";
#youtube-dl --external-downloader aria2c --external-downloader-args "--split=6 --min-split-size=5M --max-connection-per-server=6" --no-playlist -f worst -i -o "./media/video/%(uploader)s/%(title)s.%(ext)s" --exec 'reduce_video.sh -i {}' $1;
