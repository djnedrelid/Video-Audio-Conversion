@echo off
setlocal enabledelayedexpansion

set /p "folder=Full path to folder to be converted: "
set folder=%folder:"=%
set output_folder=flac_files
set loggfil=result.log

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
for %%f in ("%folder%\*.m4a") do (
    :: Extract the filename without extension for the title
    set "title=%%~nf"
    set "output=%folder%\%output_folder%\%%~nf.flac"

    ffmpeg -i "%%f" -c:a flac -map_metadata 0 "!output!" -y >> %loggfil% 2>&1
	echo !output! - Converted.
)

echo Conversion complete. FLAC files saved in "%folder%\%output_folder%" directory.
pause
