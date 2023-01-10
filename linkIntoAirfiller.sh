#!/bin/bash

parentTree="$(echo $1 | rev | cut -d '/' -f 2- | rev)" 
echo $parentTree
mkdir -vp "$2/$parentTree"
ln -sv "$1" "$2/$parentTree"
