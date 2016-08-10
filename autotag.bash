#!/bin/bash

filename=$1

# year
regex="(.*) \(([0-9]{4})\)(.*)"
if [[ "$filename" =~ $regex ]]
then
	year=${BASH_REMATCH[2]}
	echo "year: $year"
	id3v2 --year "$year" "$filename"
	newname=${BASH_REMATCH[1]}""${BASH_REMATCH[3]}
	mv "$filename" "$newname"
	filename=$newname
fi

# remove id
regex="(.*) - (.*)-[a-zA-Z0-9\_]*\.mp3"
if [[ "$filename" =~ $regex ]]
then
	newname=${BASH_REMATCH[1]}" - "${BASH_REMATCH[2]}".mp3"
	mv "$filename" "$newname"
	echo "$newname renamed"
	filename=$newname
fi

regex="(.*) - (.*).*\.mp3"
if [[ "$filename" =~ $regex ]]
then
	echo "matches"
	artist=${BASH_REMATCH[1]}
	second=${BASH_REMATCH[2]}
	id3v2 --artist "$artist" "$filename"
	echo "artist: $artist"
	# album/song
	regex1="(.*) \[(.*)\]"
	regex2="(.*) \((.*)\)"
	if [[ $second =~ $regex1 ]] || [[ $second =~ $regex2 ]]
	then
		album=${BASH_REMATCH[1]}
		echo "album: $album"
		id3v2 --album "$album" "$filename"
		newname="$artist - ${BASH_REMATCH[1]}.mp3"
		mv "$filename" "$newname"
		filename=$newname
	else
		song=$second
		echo "song: $song"
		id3v2 --song "$song" "$filename"
	fi
else
	echo "doesn't match!"
fi

echo "filename: $filename"
