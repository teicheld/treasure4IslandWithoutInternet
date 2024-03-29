[ -z $1 ] && echo provide url and optional the destinationDir to save to && exit
name="$(echo $1 | rev | cut -d '/' -f1 | rev)"
if [ -z "$name" ]; then name="$(echo $1 | rev | cut -d '/' -f2 | rev)"; fi
[ -n "$2" ] && destinationDir=$2 || destinationDir=~/media/text/
destination="${destinationDir}/${name}.txt"
curl "$1" | html2text > "$destination"
echo $destination
