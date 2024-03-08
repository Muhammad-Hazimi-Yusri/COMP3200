@echo off
if not exist output mkdir output
if not exist temp mkdir temp
if not exist input (
   mkdir input
   echo "Place videos in input and run again"
   PAUSE
   exit
)
   
for /f %%f in ('dir /b input') do (
  echo %%f
  ffmpeg -i input\%%f -map 0:0 -vcodec copy -map 0:1 -acodec copy temp\temp1.avi
  ffmpeg -i input\%%f -map 0:2 -vcodec copy -map 0:1 -acodec copy temp\temp2.avi
  ffmpeg -i temp\temp1.avi -i temp\temp2.avi -filter_complex "[0:v]setpts=PTS-STARTPTS, pad=iw*2:ih[bg]; [1:v]setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=w" output\%%~nf.MP4
  del temp\temp1.avi
  del temp\temp2.avi
)