@echo off

echo Running metadata tagging script...
python run-metadata-tagging.py

:wait_loop
tasklist /fi "imagename eq python.exe" /fo csv 2>NUL | find /i "run-metadatatagging.py" >NUL
if %ERRORLEVEL% equ 0 goto wait_loop

echo Running stitching script...
python run-stitch.py

echo Done!
pause