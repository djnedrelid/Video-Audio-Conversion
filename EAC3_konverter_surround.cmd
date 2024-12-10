@echo off
chcp 65001
cd %~dp0
cls
title EAC3 5.1 Konverter

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

:: Konverter kun første spor og kopier resten som de er, siden dette er til surround og kanskje noen er stereo.
ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1536k -ac 6 -metadata:s:a:0 title="Dolby Digital+ 5.1" -c:a copy %sti%.tmp.%ekstensjon%
move /y %sti%.tmp.%ekstensjon% %sti%

echo Ferdig ...
pause
goto start