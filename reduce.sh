#!/bin/bash
parallel -u '
	outExt="$(echo {} | rev | cut -d '.' -f 1 | rev)"
	ffmpeg -i '"{}"' -r 7 -vf scale=200:-2 "{}_reduced.$outExt"
	'
