#!/bin/bash

newName="$(echo $1 | sed 's/(copied)//g')"
if [ "$1" != "$newName" ]; then mv "$1" "$newName" -v; fi
