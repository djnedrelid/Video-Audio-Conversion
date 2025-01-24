@echo off
chcp 65001
cd %~dp0
setlocal enabledelayedexpansion
:: Trenger bruk av !var! i if blokker for sanntidsevaluering.
set logfile=Convert_Audio_Manually.log
del %logfile% > nul 2>&1
title AC3 Stereo Converter

::
:: A script made to convert video audio to player compatible AC3 & E-AC3 formats.
::
:: Noen notater:
::
:: Kopiere kun ut lyd for analysering:
:: ffmpeg -i movie.mkv -map 0:a:0 -c copy audio.eac3

:: Eksportere lyd til WAV for å sjekke klipping i audacity:
:: ffmpeg -i movie.mkv -vn -f segment -segment_time 1800 -map 0:a:0 -c:a pcm_s16le movie_%03d.wav
::

:: Sjekk om ffmpeg er tilstede.
where ffmpeg.exe >nul 2>&1
if errorlevel 1 (
    echo Error: ffmpeg.exe was not found here or in PATH.
	echo You can use the one included in ffmpeg.rar archive.
    pause
    exit /b
)

:start
:: Nullstill variabler fra forrige kjøring.
set sti=
set lang=
set highervoiceval=
set includeLFE=
set keeporigtrack=
set convertinstead=
set convertaudioto=
set keeporigfile=
cls

:: Spør om sti til videofil.
echo.
set /p "sti=Full path to video file: "
if "!sti!"=="" (
	set /p tryagain=Invalid input, try again [press enter]
	goto :start
)

:: Spør om språk som skal angis til nye spor. Samme kilde = samme språk.
echo.
echo Script will base itself on the first available audio stream.
echo https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
set /p "lang=What is the ISO 639-2 language code of that stream? [eng]: "
if "%lang%"=="" (set lang=eng)

::
:: Notater rundt forsterket senterkanal i nedmiksing.
:: TEORI: 
::   Når 2 lydkilder spiller samme lyd, øker dB/SPL med ca 3dB.
::   Hvis de 2 kildene har helt like faser, øker dB/SPL med ca 6dB.
::   Dette er pga. hvordan faser kombineres og da dobles pga. lydtrykk.

::   Når man mikser lyd benyttes det lineære gain multiplikatorer.
::   1.0 gain = 0dB som fungerer som en normalisert verdi man kan bruke.
::
::   Eksempelvis ved fordeling av senterkanal til L og R:
::   1.0 + 1.0 = 2.0 men egentlig 4(2^2) siden like faser dobler energien.
::   For å sikre en riktigere energifordeling kan man bruke kvadratrot.
::   Dvs. √(1/2)=0.707 + √(1/2)=0.707 = 1.414 som tilsvarer 2.0(1.414^2).
::   0.707 verdien er en industri-standard ved f.eks. senterkanal nedmiksing.
::
:: Matematiske formler som også kan brukes:
::   dB til Normalisert Tall: 10^(desibel/20)
::   Normalisert Tall til dB: log(Normalisert Tall)*20
::
:: Ved å bruke formlene, kan man eksempelvis se at:
::   0.707*2 = 1.414 = log(1.414)*20 = 3dB
::   Ved å spille av 3dB samlet i samme fase, får man i praksis 3^2 = 6dB energi.
::   Som gjør opp for at begge kanaler spiller senter mikset med -3dB per kanal.
::
:: Anbefalt forsterkning er satt mellom 0.707(standard -3dB) og 1.707(4.64dB).
:: For å unngå digital klipping, settes volum til -6dB ved output.
::
:: Den opplevde energien kan bli 4.649*2 = 9.3dB + 6dB pga. faseforsterkning.
:: Denne dB summeringen er mer en potensiell opplevelse av lydnivå og kan variere.
::
echo.
echo dB and Linear Gain Multiplier Relationship:
echo dB to Normalized value: 10^(decibel_value/20)
echo Normalized value to dB: log(normalized_value)*20
echo Recommended value is between 0.707(Standard -3dB) and 1.707(4.65dB).
set /p "highervoiceval=Enter desired gain for the center channel mix [1.707]: "
if "!highervoiceval!"=="" (set highervoiceval=1.707)


:: More options.
echo.
set /p "includeLFE=Include LFE in stereo track (could cause digital clipping) (yes/no)? [no]: "
if "%includeLFE%"=="" (set includeLFE=no)
set LFEstring=0.0*LFE
if "%includeLFE%"=="yes" (set LFEstring=0.707*LFE)

echo.
set /p "keeporigtrack=Keep original audio stream? (yes/no)[no]: "
if "%keeporigtrack%"=="" (set keeporigtrack=no)
set convertinstead=no
if "%keeporigtrack%"=="no" (
	echo.
	set /p "convertinstead=Do you want to directly convert the audio instead to a single track? (yes/no)[no]: "
	if "!convertinstead!"=="yes" (
		set /p "convertaudioto=What kind of track? EAC3 5.1 = 0, AC3 2.0 = 1, AC3 Higher Voices 2.0 = 2 [2]: "
		if "!convertaudioto!"=="" (set convertaudioto=2)
	)
)

echo.
set /p "keeporigfile=Keep original video file? (yes/no)[no]: "
if "%keeporigfile%"=="" (set keeporigfile=no)

:: Flytt videofil til midlertidig avlesingsfil (ffmpeg kan ikke skrive til en kildefil).
move /y %sti% %sti%.audcon

:: Konvertering til et enkelt lydspor i stedet for remuxing?
if "%keeporigtrack%"=="no" (
	if "%convertinstead%"=="yes" (
	
		:: Surround
		if "%convertaudioto%"=="0" (
			set cmd=-i %sti%.audcon -map 0:v -map 0:s? -map 0:a:0 -c:v copy -c:s copy -c:a:0 eac3 -b:a:0 1536k -ac 6 -af "volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="Dolby Digital+ 5.1" %sti%
			echo %time% Converting to Surround: !cmd! >> %logfile%
			ffmpeg !cmd!
			goto :ryddopp
		)
		
		:: Normalisert.
		if "%convertaudioto%"=="1" (
			set cmd=-i %sti%.audcon -map 0:v -map 0:s? -map 0:a:0 -c:v copy -c:s copy -c:a:0 ac3 -b:a:0 640k -ac 2 -af "volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="Dolby Digital 2.0" %sti%
			echo %time% Converting to Normalized: !cmd! >> %logfile%
			ffmpeg !cmd!
			goto :ryddopp
		) 
		
		:: Higher Voices.
		if "%convertaudioto%"=="2" (
			set cmd=-i %sti%.audcon -map 0:v -map 0:s? -map 0:a:0 -c:v copy -c:s copy -c:a:0 ac3 -b:a:0 640k -af "pan=stereo|c0=1.0*FL+0.707*SL+%highervoiceval%*FC+%LFEstring%|c1=1.0*FR+0.707*SL+%highervoiceval%*FC+%LFEstring%,volume=-6dB" -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="DD 2.0 HigherVoice" %sti%
			echo %time% Converting to HigherVoice: !cmd! >> %logfile%
			ffmpeg !cmd!
			goto :ryddopp
		)
	)
)

::
:: Bygg complex_filter basert ffmpeg kommando.
:: -------------------------------------------
:: out1 = orginalspor
:: out2 = eac3 5.1
:: out3 = ac3 2.0
::
set complex_filter="[0:a:0]asplit=2[out1][out2];[out1]pan=5.1|c0=FL|c1=FR|c2=FC|c3=LFE|c4=SL|c5=SR[a1];[out2]pan=stereo|c0=1.0*FL+0.707*SL+%highervoiceval%*FC+%LFEstring%|c1=1.0*FR+0.707*SL+%highervoiceval%*FC+%LFEstring%,volume=-6dB[a2]"
if "%keeporigtrack%"=="yes" (
	set cmd=-i %sti%.audcon -filter_complex !complex_filter! -map 0:v -map 0:a:0 -map "[a1]" -map "[a2]" -map 0:s? -c:v copy -c:s copy -c:a:0 copy -c:a:1 eac3 -b:a:1 1536k -c:a:2 ac3 -b:a:2 640k -metadata:s:a:1 language=%lang% -metadata:s:a:1 title="Dolby Digital+ 5.1" -metadata:s:a:2 language=%lang% -metadata:s:a:2 title="Dolby Digital 2.0" %sti%
	echo %time% KEEPING original track: !cmd! >> %logfile%
	ffmpeg !cmd!
) else (
	set cmd=-i %sti%.audcon -filter_complex !complex_filter! -map 0:v -map "[a1]" -map "[a2]" -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a:0 1536k -c:a:1 ac3 -b:a:1 640k -metadata:s:a:0 language=%lang% -metadata:s:a:0 title="Dolby Digital+ 5.1" -metadata:s:a:1 language=%lang% -metadata:s:a:1 title="Dolby Digital 2.0" %sti%
	echo %time% NOT KEEPING original track: !cmd! >> %logfile%
	ffmpeg !cmd!
)


:: Rydd opp.
:ryddopp
if "%keeporigfile%"=="no" (
	del %sti%.audcon
) else (
	move /y %sti%.audcon %sti%.orig
)

echo Done ...
set /p fortsett=Press enter to do another or close this window.
goto start