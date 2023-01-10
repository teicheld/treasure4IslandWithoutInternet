#!/bin/bash

if [ ! -f "${1}.txt"  ] && [ ! -f "${1}.txt(copied)" ]; then echo "$1"; fi
