@echo off
chcp 65001
cd %~dp0
setlocal enabledelayedexpansion
cls

:: Spør om sti til videofil.
echo.
set /p "sti=Full path to video file: "
if "!sti!"=="" (
	set /p tryagain=Invalid input, try again [press enter]
	goto :start
)

echo.
set /p "streamnum=What audio stream number (first=0, second=1, etc)? [0]: "
if "%streamnum%"=="" (set streamnum=0)

mkdir tmp >nul 2>&1
ffmpeg -i %sti% -vn -f segment -segment_time 1800 -map 0:a:%streamnum% -c:a pcm_s16le tmp\DumpedToWAV_%%03d.wav

echo.
echo Done.
set /p fortsett=The WAV files are in the tmp folder ready for inspection.