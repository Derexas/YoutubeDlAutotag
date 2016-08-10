#!/bin/bash

url=$1

title="$(youtube-dl --get-title "$url")"
id="$(youtube-dl --get-id "$url")"

youtube-dl --extract-audio --audio-format mp3 --title --prefer-ffmpeg --no-warnings "$url"
echo $title
echo "$title-$id.mp3"
./autotag.bash "$title-$id.mp3"

dir="/media/hydrogen/OS/Users/Hydrogen/Music/"
mv "$title.mp3" "$dir"
echo "$title.mp3 moved to $dir"
