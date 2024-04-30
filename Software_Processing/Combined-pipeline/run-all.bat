@echo off


echo Running convert mjpeg to mkv script...
python 0.5run-convert-mjpeg-to-mkv.py

:wait_convert_mjpeg_to_mkv
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "0.5run-convert-mjpeg-to-mkv.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_convert_mjpeg_to_mkv

echo Running rotate all 180 script...
python 0.75run-flip-vertical-all.py

:wait_rotation_all_180
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "0.75run-flip-vertical-all.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_rotation_all_180

echo Running metadata tagging script...
python 1run-metadata-tagging.py

:wait_metadata_tagging
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "1run-metadata-tagging.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_metadata_tagging

echo Running stitching script...
python 2run-stitch.py

:wait_stitch
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "2run-stitch.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_stitch

echo Running json copy script...
python 3run-copy-json.py

:wait_copy_json
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "3run-copy-json.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_copy_json

echo Running analyse jsons script...
python 4run-analyse-jsons.py

:wait_analyse_jsons
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "4run-analyse-jsons.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_analyse_jsons

echo Done!
pause
