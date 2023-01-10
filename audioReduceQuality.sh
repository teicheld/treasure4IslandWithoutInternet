#!/bin/bash
parallel ffmpeg -i "{}" -c:a libopus -ac 1 -ar 16000 -b:a 8K -vbr constrained "{}".opus
