function createIso {
	truncate --size=4482M ~/DVDcreator/DVD$nextDVD.iso # losetup cannot work with the power of 10. it results in cutting of the end of the image, which results in a mounting error, which can circumwented by providing -o ro,noload option to mount. you have to use the binary steps of counting, the MB instead of the M for truncate. i calculated the correct value through 4700000000/1024/1024 and throwing away the rest.
	if [ -f ~/DVDcreator/DVD$nextDVD.iso ]; then echo "created ~/DVDcreator/DVD$nextDVD.iso"; else echo "couldnt create ~/DVDcreator/DVD$nextDVD.iso"; exit; fi
}
function close {
	sudo umount --verbose ~/DVDcreator/decryptedDVD*
	sudo cryptsetup --verbose luksClose /dev/mapper/decryptedDVD*
	sudo losetup --verbose --detach-all
}

function purge {
	close
	sudo rm -rv ~/DVDcreator
}

if [ ! $1 ]; then echo provide a password as argument; exit; fi
if [ $1 ] && [ $1 == 'close' ] ; then close; exit; fi
if [ $1 ] && [ $1 == 'purge' ] ; then purge; exit; fi

mkdir -vp ~/DVDcreator/
nextLoop=$(($(lsblk | grep loop | cut -d ' ' -f1 | sed 's/loop//' | tail --bytes=2) + 1)) # works only from loop1-loop9
nextDVD=$(($(cd ~/DVDcreator; ls DVD*.iso 2>/dev/null | sed 's/DVD//;s/.iso//' | tail --bytes=2)+1)) # cannot go over 9
mkdir -v ~/DVDcreator/decryptedDVD$nextDVD
createIso
sudo losetup --verbose /dev/loop$nextLoop ~/DVDcreator/DVD$nextDVD.iso || exit # --sector-size 1KB does not work
echo $1 | sudo cryptsetup --verbose luksFormat /dev/loop$nextLoop || exit
echo $1 | sudo cryptsetup --verbose luksOpen /dev/loop$nextLoop decryptedDVD$nextDVD || exit
sudo mkfs.ext4  -v /dev/mapper/decryptedDVD$nextDVD || exit
sudo mount --verbose /dev/mapper/decryptedDVD$nextDVD ~/DVDcreator/decryptedDVD$nextDVD || exit
sudo chmod -R 775 ~/DVDcreator
sudo chown $USER:$USER -R ~/DVDcreator/
