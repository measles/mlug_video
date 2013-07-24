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
date=`date +%d.%m.%Y`

# 4:3
#streaming_aspect="4:3"
#streaming_res="320x240"
# 16:9
streaming_aspect="16:9"
streaming_res="360x288"
metadata_title="linuxovka $date"

if [ "$1" == '-s' ]; then
	if [ -z $2 ]; then
		echo "Streaming requested but no address given"
		exit 1
	fi

	streaming_adress="$2"
	streaming="-f flv -vcodec flv -s $streaming_res -aspect 16:9 -qscale 3.5 -acodec libmp3lame -ab 24k -ar 22050 $streaming_adress"
fi

dvgrab - | \
	ffmpeg -deinterlace -i - \
	-f matroska -vcodec h263p -qscale 3.5 -acodec libvorbis -ar 22050 \
	`date +%d.%m.%Y-%H.%M.%S`.mkv \
	$streaming
