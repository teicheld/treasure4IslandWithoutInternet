#!/bin/bash

tty > /home/fe/.autoremount.tty

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
		-p|--pName)
			pName="$2"
			shift
			shift
			;;
		-s|--sleep-time)
			sleepTime="$2"
			shift
			shift
			;;
		-u|--usb_dev)
			usb_dev="$2"
			shift
			shift
			;;
		*)
			echo "usage: [-p|--pid <pid>] [-s|--sleep-time <seconds>] [-u|--usb_dev] #(e.g.:3-1, see lsusb -t)"
			echo "pauses and resumes the process in the case of hdd failure and repair"
			exit
	esac
done

## uncomment this if your cryptsetup is inside a partition
## outcomment this if your cryptsetup is over the whole disk
# $partitionNum=1
if [ !$usb_dev ]
then
	usb_dev='3-1'
fi

function reconnect_usb
{
	echo $usb_dev | tee '/sys/bus/usb/drivers/usb/unbind'
	echo $usb_dev | tee '/sys/bus/usb/drivers/usb/bind'
}

function umount_and_close {
	echo stopping $pName
	pkill -STOP $pName
	if [ "$(cat /proc/mounts | grep /mnt)" ]; then
		umount /mnt
	fi
	if [ -e /dev/mapper/decrypted ]; then
		cryptsetup luksClose decrypted
	fi
}

function open_and_mount {
	dev=$(lsblk | grep sd | cut -d ' ' -f 1 | awk NR==1)
	if [ "$(echo $dev | grep sd.)" ]; then
		echo Aa,8888888899999999910 | cryptsetup luksOpen /dev/${dev}$partitionNum decrypted && mount /dev/mapper/decrypted /mnt && {
			#play /home/fe/.jo.wav 
			echo "continuing $pName"
			pkill -CONT $pName
		} || {
			echo failure
}

function remount {
	umount_and_close
	open_and_mount
}

amIsuperUser=$(if [ ! "$(touch /etc/foo 2>&1 | grep 'Permission denied')" ]; then echo 1; rm /etc/foo; fi)
if [ ! $amIsuperUser ]; then
	echo give me super user power!
	exit
fi

if [ $1 ]
then
	if [ $1 == --sleepTime ]
	then
		sleepTime=$2
	elif [ $1 == --usb-device ]
	then
		usb_dev=$2
	elif [ $1 == --help ]
	then
		echo autoremount.sh [ --sleeptime TIME ] [ --usb-device BUS-PORT ]
		echo
		echo '--usb-device: If you have a buggy usb-device as I have...'
		echo 'Which "BUS-PORT" corresponds to my device?'
		echo 'Execute lsusb -t:'
		echo 'Example:'
		echo '/:  Bus 03.Port 1: Dev 1, ...'
		echo '	  |__ Port 1: Dev 5, If 0, YOUR DEVICE'
		echo 'then BUS-PORT=3-1, so provide "--usb-device 3-1".'
		exit
	fi
fi
if [ $3 ]
then
	if [ $3 == --sleepTime ]
	then
		sleepTime=$4
	elif [ $3 == --usb-device ]
	then
		usb_dev=$4
	fi
fi
if [ ! $sleepTime ]
then
	sleepTime=5
fi

while :;
do
#	if [ $usb_dev ] && [ ! "$(lsblk | grep sd)" ]
#	then
#		echo "buggy usb is not visible... reconnecting it assuming that it is bus-device=$usb_dev"
#		reconnect_usb
#		sleep 1
#	fi
	if [ ! "$(lsblk | grep crypt | grep -o /mnt)" ]
	then 
		echo trying to remount...
		remount
	fi
	sleep $sleepTime
done
