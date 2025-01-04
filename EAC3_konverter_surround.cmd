@echo off
chcp 65001
cd %~dp0
cls
title EAC3 5.1 Converter

:start
cls
echo.
echo Full path to file being converted? 
echo.
set /p sti=:

:: Ta med og konverter kun første spor, unngå forsøk på oppskalering. Forventes minst 5.1 kanaler input f.eks. lossless TrueHD 7.1 etc.
move /y %sti% %sti%.audcon
ffmpeg -i %sti%.audcon -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1536k -ac 6 -af "volume=-6dB" -metadata:s:a:0 title="Dolby Digital+ 5.1" %sti%
del %sti%.audcon

echo Done ...
pause
goto start


:: NOTATER:
:: -------

:: Kopiere kun ut lyd for analysering:
:: ffmpeg -i movie.mkv -map 0:a:0 -c copy audio.eac3


:: Nedmikse f.eks. eac3 6ch til 3x ac3 2ch ekstra lydspor som remukses tilbake til video for flere lydvalg:
:: TEORI: Når man deler en lyd til 2 kilder, vil de føre til forsterket lyd og i praksis doble seg.
::        Dvs. 1.0 + 1.0 = 2.0 = 4.0 i faktisk energi.
::        Derfor bruker man kvadratrot for å regne ut riktig deling slik at energi blir riktig.
::        Dvs. √(1/2)=0.707 + √(1/2)=0.707 = 1.414 = 2.0 i faktisk energi.
::        Det er derfor denne verdien brukes ved fordeling av f.eks. senterkanal og normalisert desibel.
::
:: Remukser 3 ekstra spor til en video:
::  - Ett med standard lydnivåer, 
::  - Ett med høyere center/dialog, 
::  - Ett med høyere center/dialog og vanlig LFE.
:: ffmpeg.exe -i "Tenet (2020).HBYT.mkv" -map 0:a:0 -c copy 6ch.eac3
:: ffmpeg -i 6ch.eac3 -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+0.707*FC+0.0*LFE|c1=1.0*FR+0.707*SL+0.707*FC+0.0*LFE,volume=-6dB" -metadata:s:a:0 title="DD 2.0 Normal" 2ch_normal.ac3
:: ffmpeg -i 6ch.eac3 -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+1.0*FC+0.0*LFE|c1=1.0*FR+0.707*SL+1.0*FC+0.0*LFE,volume=-6dB" -metadata:s:a:0 title="DD 2.0 HighCenter" 2ch_highcenter.ac3
:: ffmpeg -i 6ch.eac3 -c:a ac3 -b:a 640k -filter_complex "[0:a]pan=stereo|c0=1.0*FL+0.707*SL+1.0*FC+0.707*LFE|c1=1.0*FR+0.707*SL+1.0*FC+0.707*LFE,volume=-6dB" -metadata:s:a:0 title="DD 2.0 HighCenterLFE" 2ch_highcenterLFE.ac3
:: ffmpeg -i "Tenet (2020).HBYT.mkv" -i 2ch_normal.ac3 -i 2ch_highcenter.ac3 -i 2ch_highcenterLFE.ac3 -map 0 -map 1:a:0 -map 2:a:0 -map 3:a:0 -c:v copy -c:a copy -c:s copy -metadata:s:a:1 title="DD 2.0 Normal" -metadata:s:a:2 title="DD 2.0 HighCenter" -metadata:s:a:3 title="DD 2.0 HighCenterLFE" "Tenet (2020).mkv"


:: Eksportere lyd til WAV for å sjekke klipping i audacity:
:: ffmpeg -i "Wonder Woman (2017)\Wonder Woman_t01.mkv" -vn -f segment -segment_time 1800 -map 0:a:0 -acodec pcm_s16le ww_2ch_truehd%03d.wav

:: Konvertere med nedsatt volum for å unngå klipping:
:: ffmpeg.exe -i "Wonder Woman (2017)\Wonder Woman_t01.mkv" -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 ac3 -b:a 640k -ac 2 -af "volume=-6dB" ww_2ch_auto_-6dB.mkv

:: DRC (dynamic range control/compression) som utjevner lyd for lav avspilling (ser ikke ut som ffmpeg støtter DRC håndtering med/fra lossless formater).
:: ffmpeg.exe -drc_scale 0 -i "Wonder Woman_t01.mkv" -map 0:v -map 0:a:0 -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1532k -ac 6 ww_2ch_drc0.mkv