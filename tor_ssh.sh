#!/bin/bash
[ $USER != "root" ] && echo "brauche Adminrechte um die TOR Tuere zu veraendern..." && exit
[ ! $1 ] && cat << EOF
Benutzung:
tor_ssh.sh [oeffne] [schliesse] [zeige]
EOF
if [ "$1" == "oeffne" ]; then
	[ ! -f /usr/bin/tor ] && apt install tor
	if [ ! "$(grep "sshDJDJDLWJEOW" /etc/tor/torrc)" ];
	then
		cp -v /etc/tor/torrc /etc/tor/torrc.cp
		echo "adding to /etc/tor/torrc:"
		cat << EOF | tee -a /etc/tor/torrc
		HiddenServiceDir /var/lib/tor/sshDJDJDLWJEOW/
		HiddenServicePort 22 127.0.0.1:22
EOF
		systemctl restart tor && sleep 1
	else
		echo "habe die tuere ein vorheriges Mal geoeffnet. Die Addresse lautet:"
	fi
	cat /var/lib/tor/sshDJDJDLWJEOW/hostname
elif [ "$1" == "schliesse" ]; then
	mv -v /etc/tor/torrc.cp /etc/tor/torrc
	rm -rv /var/lib/tor/sshDJDJDLWJEOW/
	systemctl restart tor
elif [ "$1" == "zeige" ]; then
	cat /var/lib/tor/sshDJDJDLWJEOW/hostname
fi
