#!/bin/bash
find /mnt/myLibrary/files/internetarchive/ -type f -name '*.epub' | while read line; do convertEpubOrNot.sh "$line"; done | parallel 'pandoc -f epub -t plain -o '{}.txt' '{}' || echo '{}' >> pandocError; printf .;'
