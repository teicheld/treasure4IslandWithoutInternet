#!/bin/bash

#####################################################functions###############################################################################################

function flash {
	read -p "power off your smartphone and hold the buttons: home + volume down + power"
	read -p "press here enter if your smartphone is connected with this machine over usb and is in download-mode"

	if [ 'l' == $os ] && [ -f twrp* ]
	then
		echo already downloaded file twrp* found. Using this. If you like to download another version, run \'rm files/twrp*\'.
		recovery=twrp*
	else
		read -p "what is the codename of your smartphone?" codename
		echo "doubleckick on the disired version and press enter:"
		curl https://eu.dl.twrp.me/$codename/ | grep -o twrp-.*-$codename.img | sed "s/-$codename.*//; s/twrp-//; s/^/'/; s/$/'/" | uniq | awk 'NR<10' | tr '\n' ' '
		read
		version=$(xclip -out)
		wget "https://eu.dl.twrp.me/$codename/twrp-${version}-$codename.img" --referer="https://eu.dl.twrp.me/$codename/twrp-${version}-$codename.img"
		recovery="twrp-${version}-$codename.img"
	fi


	if [ 'r' == $os ]
	then
		wget 'https://ftp-osl.osuosl.org/pub/replicant/images/replicant-6.0/0003/images/$codename/recovery-$codename.img'
		recovery="recovery-$codename.img"
	fi
	echo "executing sudo heimdall flash --RECOVERY $recovery --no-reboot"

	sudo heimdall flash --RECOVERY $recovery --no-reboot
	read -p "press and hold home + volume up + power until the logo appears."
	if [ 'l' == $os ]
	then
		echo "if you are entering download mode you either pressed volume down or you should try another version of the bootloader"
	fi
	echo "if android boots up, your bootloader is overwritten and you can try the same version again. then we have to repeat." 
	echo "are you in the bootloader? [y/n]" 
	read answer
	if [ 'y' == $answer ]
	then
		flashed=1
	fi
}

function sideload_OS {
	if [ 'r' == $os ]
	then
		if [ 'replicant-6.0-i9300.zip' != $os_file ]
		then
			wget 'https://ftp-osl.osuosl.org/pub/replicant/images/replicant-6.0/0003/images/i9300/replicant-6.0-i9300.zip'
			os_file='replicant-6.0-i9300.zip'
		fi
	else 
		if [ -f lineage* ]
		then
			os_file=lineage*
			echo $os_file
			echo taking existing file ${os_file}. If you want to use another one, then delete the existing one through executing the command \"rm $(pwd)/lineage*\".
		else
			echo "copy the direct link to your favorite version to clipboard (has to end with '.zip' extension if you have choosen it correct)"
			echo "get it from https://androidfilehost.com/?w=search&s=$codename"
			read -p 'press Enter if your clipboard hold the link'
			link=$(xclip -out -selection clipboard)
			wget $link
			os_file=$(echo $link | rev | cut -d '/' -f 1 | rev)
		fi
	fi
	adb sideload $os_file
	echo "if you failed with different lineage-versions, then stop this script and restart to start with another bootloader version"
	echo "succseeded? [y/n]" 
	read answer
	if [ 'y' == $answer ]
	then
		sideloaded=1
	fi
}

function append_apk {
	for i in *; do if [ $(echo $i | rev | cut -d '.' -f1 | rev) != 'apk' ]; then mv -v $i ${i}.apk; fi; done
}

function install_needed_software {
	if [ ! -f "/usr/bin/adb" ]
	then
		echo installing adb
		sudo apt install -y adb
	fi

	if [ ! -f "/usr/bin/heimdall" ]
	then
		echo installing heimdall-flash
		sudo apt install -y heimdall-flash
	fi

	if [ ! -f "/usr/bin/xclip" ]
	then
		echo installing xclip
		sudo apt install -y xclip
	fi

	if [ ! -f "/usr/bin/wget" ]
	then
		echo installing wget
		sudo apt install -y wget
	fi
}




#####################################################functions_end###########################################################################################
clear
mkdir -p files/
cd files/

install_needed_software

echo choose an operating system:
echo [r]eplicant "(fully open source. buy AR9271 wifi usb adapter and micro usb otg first)"
echo "[l]ineage (includes proprietary software)" 
read os
unset flashed
while [ ! $flashed ]
do
	flash
done

echo now select factory reset somewhere in the menu
if [ 'l' == $os ]
then
	read -p "select 'advanced' > 'adb sideload' and enter sideload-mode"
else
	read -p "select 'apply update' > 'adb sideload'"
fi

unset sideloaded
while [ ! $sideloaded ]
do
	sideload_OS
done

if [ 'l' == $os ]
then
	echo if you want to root your device, this function is actually not included in this tool. But go there: https://download.lineageos.org/extras
fi


echo reboot into your operating system and enable adb.
if [ 'r' == $os ]
then
	echo 'goto settings > developer settings > Android debugging'
else
	echo 'goto settings > about phone > tap a few times on Build number to activate dev settings'
	echo 'goto settings > system (advanced) > Developer settings > Android debugging'
fi

adb shell 'find sdcard/ -type d -empty -delete'

echo done
