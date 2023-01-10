#!/bin/bash

if [ ! $3 ]; then 
	echo usage: ./ebay-kleinanzeigen_kiss.sh searchTerm firstPrice lastPrice
	exit 1
fi

if test -f /tmp/out.html; then rm /tmp/out.html; fi
if test -f /tmp/gen_out.html.sh; then rm /tmp/gen_out.html.sh; fi
searchTermWhiteSpaced="$1"
searchTerm=$(echo "$searchTermWhiteSpaced" | sed 's/ /-/g')
priceMin=$2
priceMax=$3
#userAgent="Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US)"
#userAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246"
#userAgent="Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36"
#userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
#userAgent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"
#userAgent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1"
userAgent="Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
#userAgent="Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)"
#userAgent="Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)"
#userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
touch /tmp/gen_out.html.sh #for the firest sizeOld variable usage
for price in $(seq $priceMin $priceMax); do
	for i in $(seq 1 21); do
		echo https://www.ebay-kleinanzeigen.de/s-sortierung:preis/preis:$price:$price/seite:$i/$searchTerm/k0
		sizeOld=$(du /tmp/gen_out.html.sh | cut -f1)
		curl --silent --user-agent "$userAgent" https://www.ebay-kleinanzeigen.de/s-sortierung:preis/preis:$price:$price/seite:$i/$searchTerm/k0 | grep -e data-imgsrc= -e data-href= | sed 's#  ##g;s#data-href="#linkLocalRelative="#;s#data-imgsrc="#pic="#;s#data-imgsrc="#pic="#;s#$_2.PNG"#$_2.PNG"\nlink=https://www.ebay-kleinanzeigen.de$linkLocalRelative\n\necho "[![]($pic)]($link)" | markdown >>/tmp/out.html\n\n#;s#">#"#;s#$_2.JPG"#$_2.JPG"\nlink=https://www.ebay-kleinanzeigen.de$linkLocalRelative\n\necho "[![]($pic)]($link)" | markdown >>/tmp/out.html\nprintf "."\n#;s#">#"#' >> /tmp/gen_out.html.sh
		sizeNew=$(du /tmp/gen_out.html.sh | cut -f1)
		echo $sizeNew
		if [ $sizeOld -eq $sizeNew ]; then break; fi
	done
done
sed -i s/\"/\'/g /tmp/gen_out.html.sh
sed -i s/echo\ \'/echo\ \"/ /tmp/gen_out.html.sh; sed -i s/\)\'/\)\"/ /tmp/gen_out.html.sh
chmod +x /tmp/gen_out.html.sh
/tmp/gen_out.html.sh
wc -l /tmp/out.html
sed -i 's/<p>//' /tmp/out.html
sed -i 's/<.p>//' /tmp/out.html
firefox /tmp/out.html




