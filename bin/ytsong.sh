#!/bin/bash
# https://askubuntu.com/questions/634584/how-to-download-youtube-videos-as-a-best-quality-audio-mp3-using-youtube-dl
# youtube-dl -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0

for URL in "$@"; do
    youtube-dl --format bestaudio --extract-audio "$URL"
done
