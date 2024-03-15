@echo off

echo Running metadata tagging script...
python 1run-metadata-tagging.py

:wait_loop
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "1run-metadata-tagging.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_loop

echo Running stitching script...
python 2run-stitch.py

:wait_loop2
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "2run-stitch.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_loop2

echo Running copy JSON script...
python 3run-copy-json.py

:wait_loop3
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "3run-copy-json.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_loop3

echo Running JSON analysis script...
python 4run-analyse-jsons.py

:wait_loop4
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "4run-analyse-jsons.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_loop4

echo Done!
pause