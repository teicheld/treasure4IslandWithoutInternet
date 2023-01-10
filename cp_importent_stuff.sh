if [ ! $1 ]; then
	echo usage: cp_importent_stuff destination
	exit
elif [ ! -d "$1" ]; then
	mkdir $1
fi

cp --parent --no-clobber -v -r \
	~/Desktop/images/ \
	/usr/my_programs/ \
	~/.ssh\
	~/.local/share/Bisq/\
	~/os/arm/raspberry/config/\
	~/Desktop/programs/Freenet/\
	~/.gnupg/\
	~/.muttrc*\
	~/Desktop/0_copy_this_to_all_devices/\
	~/.bash*\
	$1
