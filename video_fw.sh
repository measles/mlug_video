#!/bin/bash

# Streaming and recording video from FireWire.
#
# Copyright © 2013 Denis Pynkin (denis_pynkin@epam.com), Andrej Zakharevich (andrej@zahar.ws)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

dtime=`date +%d.%m.%Y-%H.%M.%S`
#date=`date +%d.%m.%Y`
#metadata_title="linuxovka $date"
delay=2

if [ "$1" = '-s' ]; then
	if [ -z $2 ]; then
		echo "Streaming requested but no address given"
		exit 1
	fi

	# Defining video aspect 
	md5=`echo $dtime | md5sum`
	tempfile="/tmp/mlug_video_${md5%% *}.avi"
	dvgrab -  2>/dev/null| \
		ffmpeg -i - -an -fs 3K $tempfile 2>/dev/null

	if [ $? -eq "0" ]; then
		streaming_aspect=`mediainfo --Inform="Video;%DisplayAspectRatio/String%" $tempfile 2>/dev/null`
		rm $tempfile
	else
		echo "Failed to capture a sample."
		exit 2
	fi

	# Defining resolution for video streaming
	case "$streaming_aspect" in
		"4:3") streaming_res="320x240"
			;;
		"16:9") streaming_res="360x288"
			;;
	esac
	
	streaming_adress="$2"
	streaming="-f flv -vcodec flv -s $streaming_res -aspect $streaming_aspect -qscale 3.5 -acodec libmp3lame -ab 24k -ar 22050 $streaming_adress"
fi

capture() {
	dvgrab - | \
		ffmpeg -deinterlace -i - \
		-f matroska -vcodec h263p -qscale 3.5 -acodec libvorbis -ar 22050 \
		"$dtime.mkv" \
		$streaming &
	PID=$!
}


while true
do
	if [ -z "$PID" ]; then
		echo "Starting capture"
		capture
	elif ! kill -0 $PID 2> /dev/null; then
		echo "Capture failed. Restarting."
		capture
	fi
	sleep $delay
done
