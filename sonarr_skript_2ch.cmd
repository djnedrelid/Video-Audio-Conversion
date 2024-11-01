@echo off
chcp 65001
cd %~dp0

if defined sonarr_eventtype (

	:: Når skriptet testes i Sonarr.
	if "%sonarr_eventtype%" == "Test" (
		exit
	)
	
	:: On Import/ On Upgrade.
	if "%sonarr_eventtype%" == "Download" (

		:: Gi fil midlertidig navn.
		move "%sonarr_episodefile_path%" "%sonarr_episodefile_path%.audcon" 2>&1 >> sonarr_skript.log
		echo. >> sonarr_skript.log
		
		:: Konverter med ffmpeg til orginalnavn.
		set FFREPORT=file=sonarr_skript_ffmpeg_report.log:level=32
		ffmpeg -i "%sonarr_episodefile_path%.audcon" -map 0:v -map 0:a -map 0:s? -c:v copy -c:s copy -c:a ac3 -b:a 384k -ac 2 "%sonarr_episodefile_path%"
		echo. >> sonarr_skript.log
		
		:: Fjern midlertidig fil.
		del "%sonarr_episodefile_path%.audcon" 2>&1 >> sonarr_skript.log
		exit
	)
)
