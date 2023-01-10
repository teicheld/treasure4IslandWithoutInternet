#!/bin/bash

#### script does never exit and head variable gets never assigned
heard=$(cat /home/aichikinger/.heard)
if [ $heard -eq 0 ]; then
	espeak-ng -a 60 -v mb-de2 -m -f /home/aichikinger/.welcomeMessage.ssml
fi
let heard++
echo $heard > /home/aichikinger/.heard
