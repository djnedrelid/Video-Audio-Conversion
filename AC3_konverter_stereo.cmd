@echo off
chcp 65001
cd %~dp0
cls
title EAC3 Stereo Converter

:start
cls
echo.
echo Full path to file being converted? 
echo.
set /p sti=:

echo.
echo Container format? mp4, mkv, etc.
echo.
set /p ekstensjon=:

:: Downmix med ffmpeg automagi.
ffmpeg -i %sti% -map 0 -c:v copy -c:s copy -c:a ac3 -b:a 640k -ac 2 -af "volume=-6dB" -metadata:s:a title="Dolby Digital 2.0" %sti%.tmp.%ekstensjon%

move /y %sti%.tmp.%ekstensjon% %sti%

echo Done ...
pause
goto start