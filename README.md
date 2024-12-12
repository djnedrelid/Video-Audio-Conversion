
## Video Audio Conversion  
  
Some scripts for converting audio to AC3 2.0 and EAC3 5.1  
320 kbps per channel for AC3 stereo (640 kbps for 2 channels)  
256 kbps per channel for E-AC3 surround (1536 kbps for 6 (5.1) channels).  
  
The stereo scripts process and convert all tracks, as the source may have any number of channels.  
The surround scripts only process and convert the first track, in case some tracks are already stereo.  
  
*Extract ffmpeg.rar before using any script (archived due to GitHub size limitations).*  

**Sonarr/Radarr**  
  
1. Go to Settings > Connect  
2. Add a connection.  
3. Name it whatever.  
4. Set type to *On File Import* and path to the respective 2ch or 6ch(5.1) script.  
5. Test it and verify results.  