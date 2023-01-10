function spit_name {
	for i in {1..10}; do
		l1=$(cat $1 | wc -l)
		l2=$(cat $2 | wc -l)
		a=$(shuf -i 1-$l1 -n 1)
		b=$(shuf -i 1-$l2 -n 1)
		pre="$(awk NR==$a $1)" 
		sur="$(awk NR==$b $2)"
		echo "$pre" "$sur"
	done
}

spit_name ~/.my_programs/names/vornamen ~/.my_programs/names/nachnamen
