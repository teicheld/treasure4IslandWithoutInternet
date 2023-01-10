#!/data/data/com.termux/files/home/../usr/bin/bash

name="$(echo $1 | rev | cut -d '/' -f 1 | rev)"
torify curl "$1" | html2text > ~/media/books/"${name}.txt"
find ~/media/books/"${name}.txt" 
