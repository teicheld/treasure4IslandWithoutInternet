#!/bin/bash
[ ! $1 ] && echo argument missing && exit
mkdir -p .html
url=$1
package=$(cut -d '/' -f 6 <<< $url)
[ ! $package ] && package=$(cut -d '/' -f 5 <<< $url)
echo url:$url
echo package:$package
[ ! -f $package.html ] && curl $url > .html/$package.html || echo .html/$package.html exists already. skipping download
if [ "$(grep '<title>301 Moved Permanently</title>' .html/$package.html)" ]; then 
	echo 301 Moved Permanently
	newUrl=$(grep -o 'https.*here' .html/$package.html | cut -d '"' -f 1 | sed 's/https/http/')
	echo redirecting to $newUrl
	curl $newUrl > .html/$package.html 
fi
lineNoARMarchitecture=$(grep --line-number armeabi-v7a .html/$package.html | awk NR==1 | cut -f1 | tr -d :)
linkArm=$(tail -n+$lineNoARMarchitecture .html/$package.html | grep $package | grep -o 'https.*apk' | uniq | head -n 1)
[ ! $linkArm ] && linkArm=$(grep $package .html/$package.html | grep -o 'https.*apk' | uniq | head -n 1)
echo link = $linkArm
[ ! -f "${package}*.apk" ] && wget $linkArm || echo $(ls "${package}*.apk") already exists. skipping download
