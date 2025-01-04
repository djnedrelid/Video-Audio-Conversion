@echo off
chcp 65001
cd %~dp0
cls
title AC3 Stereo Stream Adder

:start
cls
echo.
echo Full path to video file? 
echo.
set /p sti=:
set /p lang=ISO 639-2 language code (eng,nor,spa etc):
set /p origformat=Choose source format (ac3,eac3,opus,aac,dts,dtshd,wav,flac,m4a,aiff,wma,ogg,webm,tta):

:: Baser de 3 nye tillagte sporene på første spor:
move /y %sti% %sti%.audcon
ffmpeg.exe -i %sti%.audcon -map 0:a:0 -c copy origaud.%origformat%
ffmpeg -i origaud.%origformat% -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+0.707*FC+0.0*LFE|c1=1.0*FR+0.707*SL+0.707*FC+0.0*LFE,volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="DD 2.0 Normalized" 2ch_normal.ac3
ffmpeg -i origaud.%origformat% -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+1.707*FC+0.0*LFE|c1=1.0*FR+0.707*SL+1.707*FC+0.0*LFE,volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="DD 2.0 HigherVoice" 2ch_highcenter.ac3
ffmpeg -i origaud.%origformat% -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+1.707*FC+0.707*LFE|c1=1.3*FR+0.707*SL+1.707*FC+0.707*LFE,volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="DD 2.0 HigherVoiceLFE" 2ch_highcenterLFE.ac3
ffmpeg -i %sti%.audcon -i 2ch_normal.ac3 -i 2ch_highcenter.ac3 -i 2ch_highcenterLFE.ac3 -map 0 -map 1:a:0 -map 2:a:0 -map 3:a:0 -c:v copy -c:a copy -c:s copy -metadata:s:a:0 language=%lang% -metadata:s:a:1 language=%lang% -metadata:s:a:1 title="DD 2.0 Normalized" -metadata:s:a:2 language=%lang% -metadata:s:a:2 title="DD 2.0 HigherVoice" -metadata:s:a:3 language=%lang% -metadata:s:a:3 title="DD 2.0 HigherVoiceLFE" %sti%
del 2ch_*.ac3
del origaud.%origformat%
del %sti%.audcon

echo Done ...
set /p fortsett=Press enter to do another or close this window.
goto start