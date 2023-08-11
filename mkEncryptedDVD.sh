#!/bin/bash

function install_dependencies {
	tool=cryptsetup
        [ ! -f /usr/sbin/$tool ] && sudo apt install $tool
}

function create {
	nextLoop=$(($(lsblk | grep loop | cut -d ' ' -f1 | sed 's/loop//' | tail --bytes=2) + 1)) # works only from loop1-loop9
	read -sp "Enter password (will not be echoed): " password

	mkdir -vp ~/DVDcreator/decryptedDVD$nextDVD
	truncate --size=4482M ~/DVDcreator/DVD$nextDVD.iso # losetup cannot work with the power of 10. it results in cutting of the end of the image, which results in a mounting error, which can circumwented by providing -o ro,noload option to mount. you have to use the binary steps of counting, the MB instead of the M for truncate. i calculated the correct value through 4700000000/1024/1024 and throwing away the rest.
	if [ -f ~/DVDcreator/DVD$nextDVD.iso ]; then echo "created ~/DVDcreator/DVD$nextDVD.iso"; else echo "couldnt create ~/DVDcreator/DVD$nextDVD.iso"; exit; fi
	sudo losetup --verbose /dev/loop$nextLoop ~/DVDcreator/DVD$nextDVD.iso || exit # --sector-size 1KB does not work ## losetup is used to associate loop devices with regular files
	echo $password | sudo cryptsetup --verbose luksFormat /dev/loop$nextLoop || exit
	echo $password | sudo cryptsetup --verbose luksOpen /dev/loop$nextLoop decryptedDVD$nextDVD || exit
	sudo mkfs.ext4  -v /dev/mapper/decryptedDVD$nextDVD || exit
	sudo mount --verbose /dev/mapper/decryptedDVD$nextDVD ~/DVDcreator/decryptedDVD$nextDVD || exit
	sudo chmod -R 775 ~/DVDcreator
	sudo chown $USER:$USER -R ~/DVDcreator/
}

function close {
	sudo umount --verbose ~/DVDcreator/decryptedDVD* 			#cannot use --detach-loop because cryptsetup still accesses loop device after umounting filesystem from it
	sudo cryptsetup --verbose luksClose /dev/mapper/decryptedDVD*
	sudo losetup --detach-all
}

function purge {
	close
	sudo rm -riv ~/DVDcreator
}

function mount {
	[ ! "$2" ] && echo "must provide path2file" && exit
	[ ! -f "$2" ] && echo "$2 does not exist" && exit
	sudo cryptsetup --verbose luksOpen "$2" decryptedDVD$nextDVD  || exit		# cryptsetup handles the loopStuff automatically, but its interesing to have this bunch of not wrong extra code up there :) (and wierdly I hold on on things which took me some effort while only results are counting (effort = cpy(data, brain))
	sudo mount --verbose /dev/mapper/decryptedDVD$nextDVD ~/DVDcreator/decryptedDVD$nextDVD || exit
}

function printOptions {
	printf "usage:\nmkEncryptedDVD.sh [create] [close] [purge] [mount path2file] \n"
}

install_dependencies
nextDVD=$(($(cd ~/DVDcreator 2>/dev/null &&  ls DVD*.iso 2>/dev/null | sed 's/DVD//;s/.iso//' | tail --bytes=2)+1)) # cannot go over 9

if [ "$1" ]; then
	case "$1" in
		create)
			create
			;;
		close)
			close
			;;
		purge)
			purge
			;;
		mount)
			mount	
			;;
		*)
			printOptions
			;;
	esac
else
	printOptions
fi

