#!/bin/bash

function get_f-droid {
	package="$(echo $1 | sed 's@https.*packages/@@' | tr -d /)"
	if [ "$(find . -name "*${package}*")" ]
	then
		echo taking local version of $package
	else
		newest_apk=$(curl https://f-droid.org/en/packages/${package}/ | grep ${package}.*apk | awk NR==1 | grep --only-matching f-droid.*apk)
		wget $newest_apk
		#wget -nv $newest_apk
	fi
}

function use_argument_as_input {
	while read package
	do
		get_f-droid $package
	done < $1
}

function use_stdin_as_input {
	while read package
	do
		get_f-droid $package
	done
}

function get_unconform_apks {
	tor_apks="$(find . -name '*tor-browser*.apk')"
	if [ "$tor_apks" ]; then
		echo "taking local version: $tor_apks"
	else
		wget -nv $(curl https://www.torproject.org/download/ | grep armv7 | awk NR==1 | grep -o https:.*multi.apk)
	fi
	fdroid_apks="$(find . -iname '*f-droid*.apk')"
	if [ "$fdroid_apks" ]; then
		echo "taking local version: $fdroid_apks"
	else
		wget -nv https://f-droid.org/F-Droid.apk
	fi
	vlc_apks="$(find . -name '*vlc*.apk')"
	if [ "$vlc_apks" ]; then
		echo "taking local version: $vlc_apks"
	else
		wget -nv https://f-droid.org/repo/org.videolan.vlc_13030404.apk #the newer version doesnt work(02.2021)
	fi
}

function remove_obsolete_apps {
	echo removing obsolete apks
	adb shell pm uninstall --user 0 com.android.email #because i cant send mail over web.de provider
	adb shell pm uninstall --user 0 com.android.camera2 #replaced by openCamera
	adb shell pm uninstall --user 0 org.lineageos.eleven #replaced through vlc to play youtube-dl's audio extracts
	echo removing all messy folders
	adb shell find /sdcard -empty -delete
	adb shell mkdir /sdcard/Music/
	adb shell mkdir /sdcard/DCIM/
	adb shell mkdir /sdcard/Documents/
}

if [ ! -d apks ]; then
	mkdir apks
fi
cd apks

if [ "$1" ]
then
	if [ ! -f "$1" ]
	then
		echo file "$1" not found
		exit
	fi
	use_argument_as_input "$1"
else
	use_stdin_as_input
fi

get_unconform_apks

for apk in *apk
do
	echo installing "$apk"
	adb install "$apk"
done
cd ..

remove_obsolete_apps

