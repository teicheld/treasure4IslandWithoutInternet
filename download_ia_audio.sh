mkdir "$1" -v ; cd "$1"
ia search "($1) AND mediatype:(audio)" --sort='week desc' --parameters="page=1&rows=2000" --itemlist | parallel -u -j 50 'wget https://archive.org/download/{}/{}.mp3'
cd ..
