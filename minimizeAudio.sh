ffmpeg -hide_banner -i "$1" -c:a libopus -ac 1 -ar 16000 -b:a 8K -vbr constrained "$1".opus
[ -f "${1}.opus" ] && echo "$1 > $1.opus" && rm "$1"

