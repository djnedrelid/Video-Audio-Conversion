@echo off
setlocal enabledelayedexpansion

set /p "folder=Full path to folder to be converted: "
set folder=%folder:"=%
set output_folder=aiff_files
set loggfil=ConvertFLACtoAIFF.log

where ffmpeg.exe >nul 2>&1
if errorlevel 1 (
    echo Error: ffmpeg.exe was not found here or in PATH.
    pause
    exit /b
)

:: Create output directory
if not exist "%folder%\%output_folder%" mkdir "%folder%\%output_folder%"

:: Process each M4A ALAC (Apple Lossless Audio Codec) file
del %loggfil% >nul 2>&1
for %%f in ("%folder%\*.flac") do (
    :: Extract the filename without extension for the title
    set "title=%%~nf"
    set "output=%folder%\%output_folder%\%%~nf.aiff"

    ffmpeg -i "%%f" -c:a pcm_s16be -map_metadata 0 -write_id3v2 1 "!output!" -y >> %loggfil% 2>&1
	echo !output! - Converted.
)

echo Conversion complete. AIFF files saved in "%folder%\%output_folder%" directory.
pause
