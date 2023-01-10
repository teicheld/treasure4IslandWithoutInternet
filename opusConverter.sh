#!/bin/bash

find ~/media/audio/other/ -type f -name '*opus' > opusList
cat opusList | parallel '
				preConversationFilePath="$(echo {} | sed "s/.opus//")"
				if [ -f "$preConversationFilePath" ]; then rm -v "$preConversationFilePath"; fi
			'
find ~/media/audio/other/ -type f ! -name '*.opus' | parallel ffmpeg -i '{}' -c:a libopus -ac 1 -ar 16000 -b:a 8K -vbr constrained '{}'.opus
