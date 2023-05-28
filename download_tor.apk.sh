wget $(curl https://www.torproject.org/download/ | grep armv7 | grep -o 'https.*apk"' | tr -d \")
