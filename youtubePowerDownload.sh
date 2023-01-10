function install_dependencies {
	for tool in parallel python3; do [ ! -f /usr/bin/$tool ] && sudo apt install -y $tool; done
	[ ! -f /usr/bin/aria2c ] && sudo apt install -y aria2
	[ ! -f /usr/bin/pip3 ] && sudo apt install -y python3-pip
	[ ! -f $HOME/.local/bin/youtube-dl ] && pip3 install youtube-dl
## add  $HOME/.local/bin/ to $PATH
}

install_dependencies

youtube-dl --yes-playlist --get-id "$1" | parallel -u -j 8 youtube-dl --external-downloader aria2c --external-downloader-args "'--split=8 --min-split-size=5M --max-connection-per-server=8'" --no-playlist -x -f worst -i -o '"./newShizzle/media/audio/%(uploader)s/%(title)s.%(ext)s"' {}
#youtube-dl --yes-playlist --get-id "$1" | parallel -u -j 10 youtube-dl --external-downloader aria2c --external-downloader-args "'--split=8 --min-split-size=1M --max-connection-per-server=8'" --no-playlist -x -f worst -i -o '"./media/audio/%(uploader)s/%(title)s.%(ext)s"' {}
