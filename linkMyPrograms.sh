locBin=$HOME/../usr/bin
locMyPrograms=$locBin/treasure4IslandWithoutInternet
for i in $locMyPrograms/*; do
	ln -fs "$i" "$locBin"
done
