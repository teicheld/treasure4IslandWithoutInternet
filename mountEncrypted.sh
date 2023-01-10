echo mounting encrypted $HOME/DVDcreator/DVD1.iso
echo "echo "$1" | sudo cryptsetup --verbose luksOpen ~/DVDcreator/DVD1.iso decryptedDVD1 && sudo mount --verbose /dev/mapper/decryptedDVD1 ~/DVDcreator/decryptedDVD1/"
echo "$1" | sudo cryptsetup --verbose luksOpen ~/DVDcreator/DVD1.iso decryptedDVD1 && sudo mount --verbose /dev/mapper/decryptedDVD1 ~/DVDcreator/decryptedDVD1/
