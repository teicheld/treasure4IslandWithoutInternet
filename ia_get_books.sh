if [ $2 ]; then
	echo provide searchterm as one argument by enclosing it with quotation marks.
	exit
fi
ia search "($1) AND mediatype:(texts)" --sort='week desc' --parameters="page=1&rows=2000" --itemlist | parallel -j 50 wget "https://archive.org/details/{}/{}.epub"
