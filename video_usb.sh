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

delay=2

if [ "$1" = '-s' ]; then
	if [ -z $1 ]; then
		echo "Streaming requested but no address given"
		exit 1
	fi

	streaming_adress="$1"
	streaming="-f flv -vcodec flv $streaming_adress"
fi

v4l2-ctl --set-fmt-video=width=1280,height=720,pixelformat=1
v4l2-ctl --set-parm=30

capture() {
	dtime=`date +%d.%m.%Y-%H.%M.%S`
	avconv -y -f video4linux2 -i /dev/video0 -c:v copy -f alsa -i plughw:2,0 -c:a libmp3lame \
		$streaming &
	PID=$!
}


while true
do
	if [ -z "$PID" ]; then
		echo "Starting video streaming.
		capture
	elif ! kill -0 $PID 2> /dev/null; then
		echo "Capture failed. Restarting."
		capture
	fi
	sleep $delay
done
