@echo off
chcp 65001
cd %~dp0
cls
title EAC3 Converter

:start
cls
echo.
echo Full path to file being converted? 
echo.
set /p sti=:

:: NOTATER:
:: -------

:: Eksportere lyd til WAV for å sjekke klipping i audacity:
:: ffmpeg -i "Wonder Woman (2017)\Wonder Woman_t01.mkv" -vn -f segment -segment_time 1800 -map 0:a:0 -acodec pcm_s16le ww_2ch_truehd%03d.wav

:: Konvertere med nedsatt volum for å unngå klipping:
:: ffmpeg.exe -i "Wonder Woman (2017)\Wonder Woman_t01.mkv" -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 ac3 -b:a 640k -ac 2 -af "volume=-6dB" ww_2ch_auto_-6dB.mkv

:: Downmix av kun LCR.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC|c1=FR+0.7*FC" %sti%.tmp.%ekstensjon%

:: Downmix av LCR+LFE.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC+0.3*LFE|c1=FR+0.7*FC+0.3*LFE" %sti%.tmp.%ekstensjon%

:: Downmix av LCR+LFE+SR.
::ffmpeg -i %sti% -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=FL+0.7*FC+0.3*LFE+0.3*SL|c1=FR+0.7*FC+0.3*LFE+0.3*SR" %sti%.tmp.%ekstensjon%

:: DRC (dynamic range control/compression) som utjevner lyd for lav avspilling (ser ikke ut som ffmpeg støtter DRC håndtering med/fra lossless formater).
:: ffmpeg.exe -drc_scale 0 -i "Wonder Woman_t01.mkv" -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1532k -ac 6 ww_2ch_drc0.mkv

:: -------

:: Ta med og konverter kun første spor, unngå forsøk på oppskalering. Beholder eksisterende antall kanaler.
move /y %sti% %sti%.audcon
ffmpeg -i %sti%.audcon -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1536k -af "volume=-6dB" -metadata:s:a:0 title="Dolby Digital+" %sti%
del %sti%.audcon

echo Done ...
pause
goto start