case $1 in 
	toSmartphone)
		head -n1 $2 | grep --silent "#!" && sed -i "s@!/bin@!/data/data/com.termux/files/usr/bin@" $2
		;;
	toComputer)
		head -n1 $2 | grep --silent "#!" && sed -i "s@!/data/data/com.termux/files/usr/bin@!/bin@" $2
		;;
	*)
		echo 'usage: changeBashLocationLink.sh toComputer||toSmartphone file'
		exit
		;;
esac

