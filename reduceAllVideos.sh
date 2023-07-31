#!/bin/bash

find ~/media/video/ -type f -not -name '.converting' | parallel -u reduce_video.sh -i {}
