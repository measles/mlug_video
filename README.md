mlug_video
==========

Scripts for capturing and streaming video on Minsk LUG meetings.

## video_fw.sh 
This scrip intended to capture video stream from FireWire port and store it to file named **recording-D.M.Y-H.M.S.mkv**, where D.M.Y-H.M.S is the date (day.month.year) and time (hour.minute.second) when video capturing was started.

Beside this script can send video stream to external server by RTMP protocol. In this case scrip has to be started by following command:  
`video_fw.sh -s <rtmp_adress_to_stream_to>`

For gaples rtmp streaming scipt changes video resolution to 320xsomething. At the moment there is no mechanism to define video aspect ratio, so you have to uncomment appropriate resolution in script itself (4:3 by default).

Script relies on **dvgab** and **avconv** tools, so it has to be installed if you are planning to use ths script.
