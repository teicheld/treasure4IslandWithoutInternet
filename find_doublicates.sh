if [ ! $1 ] || [ ! -d $1 ]; then
	echo provice directory as argument
	exit
fi
doublicateSizes=$(du $1/* | cut -f1 | sort | uniq -d)
du $1/* > /tmp/list
i=0
if [ -f 2rm.txt ]; then rm 2rm.txt; fi
for size in $doublicateSizes; do
	#for each size-brother
	if [ -f /tmp/brothers ]; then rm /tmp/brothers; fi
	cat /tmp/list | grep -P "^$size\t" | cut -f2 | while read line; do
						sha1sum "$line" >> /tmp/brothers
					   done
	cat /tmp/brothers | cut -d ' ' -f1 | sort | uniq -d > /tmp/doubles
	cat /tmp/doubles | while read line; do
		if [ "$(grep $line /tmp/brothers | awk NR==2)" ]; then
			toRm=$(grep $line /tmp/brothers | awk NR==1 | cut -d ' ' -f3)
			echo $toRm
			echo $toRm >> 2rm.txt
		fi
	done
done
