#!/bin/bash
textFileName="$(echo $1 | rev | cut -d . -f 2- | rev)".txt
if [ -f "$textFileName"  ]; then echo "$1"; fi
