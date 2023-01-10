#!/bin/bash
name="$(echo $1 | cut -d '/' -f 5)"
wget "$1/archive/heads/master.zip" -O "$HOME/media/text/$name.zip"
find ~/media/text/ -name "$name.zip"
