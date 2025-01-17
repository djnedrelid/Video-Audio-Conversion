
## Video Audio Conversion  
  
Some scripts I use for converting audio. 
I simply run the script and give it full path to a video file to be processed. 
Common need is e.g. a blu-ray remux/copy where I need to convert lossless to lossy for better hardware compatibility.  

320 kbps per channel for AC3 stereo (640 kbps for 2 channels)  
256 kbps per channel for E-AC3 surround (1536 kbps for 6 (5.1) channels).  
This is not black and white, downmix will dedicate bandwidth where needed.  
  
**Convert_Audio_Manually.cmd**  
A script made to convert a video's audio to player compatible AC3 2.0 and E-AC3 5.1  
Uses -filter_complex to either add or replace with AC3 and E-AC3 tracks.  
There's also the option of converting original to just a single AC3 or E-AC3 track.  
  
**OPUS_konverter.cmd**  
A basic additional conversion script that should also keep the original number of channels.  
  
**DumpToWAVforAudacityClipInspection.cmd**  
A simple script to dump any audio stream to lossless WAV for audacity digital clip inspection.  
  
**Pure Music File Folder-Conversion Scripts**  
ConvertALACtoFLAC.cmd  (default compression).  
ConvertFLACtoALAC.cmd  (default compression).  
ConvertFLACtoMP3.cmd (320k CBR MP3 (libmp3lame/LAME3.100).  
ConvertFLACtoAIFF16bit.cmd (w/ID3v2 tags/artwork).  
ConvertFLACtoWAV16bit.cmd  (w/ID3v2 tags).  
  
**ConvertFLACtoMP3.cmd**  
Another music related script, folder-conversion of FLAC files to 320k CBR MP3 (libmp3lame/LAME3.100).  
  
*Extract ffmpeg.rar before using any script (archived due to GitHub size limitations).*  
<br>
  
**Sonarr/Radarr**  
  
1. Go to Settings > Connect  
2. Add a connection.  
3. Name it whatever.  
4. Set type to *On File Import* and path to the respective 2ch or 6ch(5.1) script.  
5. Test it and verify results.  