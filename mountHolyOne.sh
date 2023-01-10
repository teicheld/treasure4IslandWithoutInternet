#if [ ! $1 ] || [ ! $2 ]; then echo provide the passwords for /dev/$devEncrypted and $HOME/DVDcreator/DVD1.iso as argument; exit; fi
if [ ! $1 ]; then echo provide the password for /dev/$devEncrypted as argument; exit; fi

devEncrypted=$(lsblk | grep 3,7T | cut -d ' ' -f 1)
echo $1 | sudo cryptsetup --verbose luksOpen /dev/$devEncrypted decrypted
sudo mount --verbose /dev/mapper/decrypted /mnt; cd /mnt; pwd; ls;

#echo mounting encrypted $HOME/DVDcreator/DVD1.iso
#echo "$2" | sudo cryptsetup --verbose luksOpen ~/DVDcreator/DVD1.iso decryptedDVD1 && sudo mount --verbose /dev/mapper/decryptedDVD1 ~/DVDcreator/decryptedDVD1/
