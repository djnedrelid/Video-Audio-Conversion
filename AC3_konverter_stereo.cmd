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

:: Downmix med ffmpeg automagi (evt. kun -map 0, inkluderer alle strømmer).
ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -ac 2 -metadata:s:a title="Dolby Digital 2.0" %sti%.tmp.%ekstensjon%

:: Downmix av kun LCR.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC|c1=FR+0.7*FC" -metadata:s:a title="Dolby Digital 2.0" %sti%.tmp.%ekstensjon%

:: Downmix av LCR+LFE.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC+0.3*LFE|c1=FR+0.7*FC+0.3*LFE" -metadata:s:a title="Dolby Digital 2.0" %sti%.tmp.%ekstensjon%

:: Downmix av LCR+LFE+SR.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC+0.3*LFE+0.3*SL|c1=FR+0.7*FC+0.3*LFE+0.3*SR" -metadata:s:a title="Dolby Digital 2.0" %sti%.tmp.%ekstensjon%


move /y %sti%.tmp.%ekstensjon% %sti%

echo Ferdig ...
pause
goto start