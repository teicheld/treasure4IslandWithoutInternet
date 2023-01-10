if [ ! -f ~/.bitcoin_keys.txt ]; then
	echo ~/.bitcoin_keys.txt not found
	exit
fi
cat ~/.bitcoin_keys.txt | awk NR==1
sed -i '1d' ~/.bitcoin_keys.txt
