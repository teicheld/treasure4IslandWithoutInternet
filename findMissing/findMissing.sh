#!/bin/bash
compFrom=$1
compTo=$2
if [ -f notFound.txt ]
then
        rm notFound.txt
fi
echo writing to notFound.txt...
find $compFrom -exec ~/.my_programs/find_missing_exec.sh '{}' $compTo \;
less notFound.txt
