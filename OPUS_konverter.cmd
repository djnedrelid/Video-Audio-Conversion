@echo off
chcp 65001
cd %~dp0
cls
title OPUS Converter

:start
cls
echo.
echo Full path to file being converted? 
echo.
set /p sti=:

:: Ta med og konverter kun første spor, unngå forsøk på oppskalering. Beholder eksisterende antall kanaler.
move /y %sti% %sti%.audcon
ffmpeg -i %sti%.audcon -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 libopus -b:a 450k -af "volume=-6dB" -metadata:s:a:0 title="OPUS" %sti%
del %sti%.audcon

echo Done ...
pause
goto start