@echo off
chcp 65001
cd %~dp0
cls
title EAC3 Stereo Konverter

:start
cls
echo.
echo Full sti til fil som skal konverteres? 
echo.
set /p sti=:

echo.
echo Hva er formatet? mp4, mkv, etc.
echo.
set /p ekstensjon=:

ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a eac3 -b:a 384k -ac 2 %sti%.tmp.%ekstensjon%
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a eac3 -b:a 384k -af "pan=stereo|c0=FL+0.5*FC|c1=FR+0.5*FC" %sti%.tmp.%ekstensjon%
move /y %sti%.tmp.%ekstensjon% %sti%

echo Ferdig ...
pause
goto start