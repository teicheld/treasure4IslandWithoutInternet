apt update
apt full-upgrade --allow-change-held-packages
pkg install root-repo  android-tools aria2 curl exiftool ffmpeg git gnupg html2text htop man mutt ncdu nmap openssh iproute2 p7zip parallel progress pwgen sed sox tar termux-api termux-tools tesseract tor torsocks vim wget python3
pkg install cryptsetup 

[ $1 == 'sever' ] && pkg install -y mariadb nginx php7 php7-fpm 
