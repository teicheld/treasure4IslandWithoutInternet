#!/bin/bash

function createDownloaderScript {
[ ! "$1" ] && echo error!! createDownloaderScript function needs two argument && exit 
cat << EOF > ~/../usr/tmp/kiriDownloader/download_minivideo.sh
youtube-dl --external-downloader aria2c --external-downloader-args "--split=16 --min-split-size=1M --max-connection-per-server=16" --no-playlist -f worst -i -o "./media/video/$1/%(uploader)s/%(title)s.%(ext)s" --exec 'reduce_video.sh -i {}' \$1;
printf .
EOF
chmod +x ~/../usr/tmp/kiriDownloader/download_minivideo.sh
}


argsRemain=()
while [[ $# -gt 0 ]]; do
        case $1 in
                -a|--amount-per-arg)
                        amount="$2"
                        shift
                        shift
                        ;;
                -h|--help)   
                        echo "usage: [-a|--amount-per-arg int] n-searchterms(whitespace seperated)"
			cat << EOF

downloads, minimizes size and packadges each searchterm.
ready for export to dvd for eternity on an lonely island :)
EOF
                        exit
			;;
		*)
		        argsRemain+=("$1") # save positional arg
			shift # past argument
		        ;;	
        esac
done
mkdir -p ~/../usr/tmp/kiriDownloader/
[ ! "${argsRemain}" ] && $0 --help && exit
[ ! $amount ] && echo "downloading 10 videos per argument" && amount=10;
for term in "${argsRemain[@]}"
do 		
	createDownloaderScript "$term"
	printf "\n###########$term###########\n\n"
	youtube-dl --get-id "ytsearch$amount:$term" | parallel -u '~/../usr/tmp/kiriDownloader/download_minivideo.sh {}'
	tar --remove-files -czf "media/video/$term".tar.gz "media/video/$term/"
	echo "media/video/$term.tar.gz: $(tar --list -f "media/video/$term.tar.gz" | grep reduced | wc -l)"
done
