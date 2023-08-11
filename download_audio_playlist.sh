function install_dependencies {
	for tool in parallel yt-dlp; do [ ! -f /usr/bin/$tool ] && sudo apt install $tool; done
	[ ! -f /usr/bin/aria2c ] && sudo apt install aria2
}

install_dependencies

#yt-dlp --yes-playlist --get-id "$1" | parallel -u -j 8 yt-dlp --external-downloader aria2c --external-downloader-args "'--split=8 --min-split-size=5M --max-connection-per-server=8'" --no-playlist -x -f worst -i -o '$HOME/media/audio/%(uploader)s/%(title)s.%(ext)s"' {}
yt-dlp --yes-playlist --get-id "$1" | parallel -u -j 8  download_audio.sh {}
