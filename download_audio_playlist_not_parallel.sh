#!/bin/bash
out=~/media/audio
yt-dlp --download-archive ~/.downloaded -x -f worst -i -N 15 -o "$out"/'%(playlist_title)s/%(title)s.%(ext)s' "$1"
