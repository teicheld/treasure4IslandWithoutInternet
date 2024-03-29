#!/bin/bash
if [ ! "$1" ]; then echo "provide a youtube id or link"; exit; fi
if [ ! "$2" ]; then out="$HOME/media/audio/"; else out="$2"; fi
yt-dlp --download-archive ~/.downloaded --external-downloader aria2c --external-downloader-args aria2c:'--quiet --split=16 --min-split-size=2M --max-connection-per-server=16' --exec 'minimizeAudio.sh {}' --no-playlist -x -f worst -i -o "$out"/'passPlaylistName/%(title)s.%(ext)s' "$1"
