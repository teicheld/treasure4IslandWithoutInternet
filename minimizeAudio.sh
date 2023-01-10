ffmpeg -hide_banner -i "$1" -c:a libopus -ac 1 -ar 16000 -b:a 8K -vbr constrained "$1".opus
[ -f "${1}.opus" ] && echo "$i > $i.opus" && rm "$1"

