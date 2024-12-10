@echo off
chcp 65001
cd %~dp0

if defined radarr_eventtype (

	:: Når skriptet testes i radarr.
	if "%radarr_eventtype%" == "Test" (
		exit
	)
	
	:: On Import/ On Upgrade.
	if "%radarr_eventtype%" == "Download" (

		:: Gi fil midlertidig navn.
		move "%radarr_moviefile_path%" "%radarr_moviefile_path%.audcon" 2>&1 >> radarr_skript.log
		echo. >> radarr_skript.log
		
		:: Konverter med ffmpeg til orginalnavn.
		set FFREPORT=file=radarr_skript_ffmpeg_report.log:level=32
		ffmpeg -i "%radarr_moviefile_path%.audcon" -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a:0 eac3 -b:a 1536k -ac 6 -metadata:s:a:0 title="Dolby Digital+ 5.1" -c:a copy "%radarr_moviefile_path%"
		echo. >> radarr_skript.log
		
		:: Fjern midlertidig fil.
		del "%radarr_moviefile_path%.audcon" 2>&1 >> radarr_skript.log
		exit
	)
)
