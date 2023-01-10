lastTimeLearned="$(cat ~/.last_time_learnpath_tracked)"
while [ $lastTimeLearned -lt $(date +%j) ]; do
	highest=000; cd ~/Desktop/shizzle/media/text/self_generated/schule_lernfortschritte/java/tag; for i in *; do if [ $highest -lt $i ]; then highest=$i; fi; done; 
	highest="$(echo $highest | sed 's/^0*//')"
	let highest++
	pwd; mkdir -v $(printf "%03d" $highest)
	let lastTimeLearned++;
done
date +%j > .last_time_learnpath_tracked
