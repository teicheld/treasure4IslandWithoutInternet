#!/bin/bash

################################################################functions##################################################################################
sayGoodbye() {
	echo "H4sIAAAAAAAAA5VPMRLAMAjafQVblzZfykd4fCNounSJnidC5CJwGIGZ8aOY/5RGQWFaVU5V89wzreUGch5g5aPXzRuPy31pQdmlE/UPo3Q0X/iuvjZOD0fEC0I3+bMtAQAA" | base64 -d | gunzip
}

printHelp () {
	echo Usage: ./powerpirate [searchTermList]
}

function getTorrentTitles {
	magnetLinksOrMore=$1
	sedPatternHex2Char='s/%28/(/;s/%2B/+/g;s/%2C/,/g;s/%29/)/g;s/%5B/[/g;s/%5D/]/g;s/%7B/{/g;s/%7D/}/g;s/%3A/:/g'
grep --only-matching 'magnet.*announce' $magnetLinksOrMore | sed "s/magnet.*&dn=//;s/&tr=.*//;s/+/ /g;$sedPatternHex2Char"
}
function createStart_downloadingsh_AndAskToStart {
	outputFolder=$1
	echo 'H4sIAL72ZmEAA5WSQW7DIBBF1/UpaLIeN22lbiKfJKoiAuN4FDxYMHbT2xdS0SC1Uhovefw/PPBamYBaUFkKaMQHwri+52uoVzv1qMAq6z/YeW2Jj+p9q2RAVs3DeErVNduqpqcq1hNTHNCWTInA8oPqQK+IjR8nh4L7dOCALLEd9ZFRHPEpXnvMlEsq1MpZbsW3edhdV/DntTQ6kH4xWXBVya8UwKjPYDyb+TIcCo3d82aTMPE0C/Tk8KYpwCHlUbQZICJa8Ow+OwkzfqOoF4QxcatFV+t53AXaX/QSiRgjef7H/Hp7OrlgWLTr3rJHWjhc7aA0qfapHf2C+/K4+7KljUOKZXHQznmjJZV27LnYZMOZFwzUU/pfKk/xEwiN6GfpXjfNF14rO+jWAgAA' | base64 -d | gunzip > "$outputFolder/start_downloading.sh"
        chmod +x "$outputFolder/start_downloading.sh"
	echo 'H4sIAJzuZmEAA21QTUsDMRA9m1/xSBdsodvS7a3iRaTam2Bv4iFuJt1ANilJtrXgj3di/QRzSOYxeR8z1uAJVYN6l7HA8xVyR15cuNCqbIO/ltWY2i5AVkuJN0Q68N0OGbXG5fwStUFTnxsTKcgl+kNeSmGsKAriLLNYoVrIT9AwaL7AkgF/dx51OrDfeH/Uk3n1JSYhjfU2daTnUoiRilY1wF6lRAlYAiruhp58ZpQD0p5aayxptKHvldc48mSwGTaBXolnID0Dth0l+sVVkVa429xOyybgh/6FIoKBsY59ik6p2Dd3zF6HiPvt9mGKdblK+5ErMcL56HD0LiidphjSoJw7/SvLkRasdmPzNsTIOb6JaJXnCXxW1qMfXLZ7dv9gMWFj/pPqQyS2YWLwNP3JW3qMYsoonRlvESrBqFieDcJLonjgjdm0+stS7qhO6SN67mzUM/EO3qT6izgCAAA=' | base64 -d | gunzip > "$outputFolder/.move_finished_download.sh"
	chmod +x "$outputFolder/.move_finished_download.sh"
	echo "created skript \"start_downloading.sh\". You can execute it now"
}

function install_dependencies {
	if [ ! -f /usr/bin/aria2c ]; then
		sudo apt install aria2
	fi
}

#################################################program_start#############################################################################
install_dependencies 
if [ "$1" ] && [ -f "$1" ]; then 
	searchTermList="$1"
elif [ ! "$1" ]; then
	randomString=$(chars=1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM; for i in {1..8} ; do echo -n "${chars:RANDOM%${#chars}:1}"; done)
	while read line
	do
		echo $line >> powerPirateResult_$randomString
	done
	searchTermList=powerPirateResult_$randomString
else
	sayGoodbye
	printHelp
	exit
fi

#removing whitespaces in the searchTerms.
[ -d /tmp/powerPirate ] && rm -r /tmp/powerPirate/
mkdir /tmp/powerPirate/
mv "$searchTermList" "/tmp/powerPirate/$searchTermList"
outputFolder="$(echo $searchTermList | sed 's/.txt//')"
mkdir -p "$outputFolder"
mv "/tmp/powerPirate/$searchTermList" "$outputFolder/topicsOfTheseBooks.txt"
searchTermList="$outputFolder/topicsOfTheseBooks.txt"
while read searchTerm
do
	searchTerm=$(echo $searchTerm | sed 's/ /%20/g')
	tooBigPageNumber=99
	rareSearchTerm=dgwf3fn3ofnsofjsodijgpfy7dghwegdy
	emptyPageLinesCount=$(curl --silent https://thepiratebay.party/search/$rareSearchTerm/$tooBigPageNumber/99/601 | wc -l)
	for (( i=1; $emptyPageLinesCount != $(curl --silent https://thepiratebay.party/search/$searchTerm/$i/99/601 | wc -l); i++ ))
	do
		clear
		echo "searchterm: $(echo $searchTerm | sed 's/%20/ /g')"
		echo "page:       $i" 
		curl --silent https://thepiratebay.party/search/$searchTerm/$i/99/601 > /tmp/powerPirate/pirateBay.tmp
		cat /tmp/powerPirate/pirateBay.tmp | grep -o "magnet:.*announce" | sed s/"amp;"//g >> "$outputFolder/magnetlinks.txt"
		getTorrentTitles /tmp/powerPirate/pirateBay.tmp
		getTorrentTitles /tmp/powerPirate/pirateBay.tmp >> "$outputFolder/titles.txt"
	done
done < "$searchTermList"
createStart_downloadingsh_AndAskToStart "$outputFolder"
sayGoodbye
