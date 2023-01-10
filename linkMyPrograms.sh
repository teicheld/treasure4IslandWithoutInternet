locBin=$HOME/../usr/bin
locMyPrograms=$locBin/.my_programs
for i in $locMyPrograms/*; do
	ln -s "$i" "$locBin" 2>/dev/null
done
