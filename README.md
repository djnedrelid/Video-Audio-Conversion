
## Video Audio Conversion  
  
Some scripts I use for converting audio.  
I simply run the script and give it full path to a video file to be processed.  
Common need is e.g. a blu-ray remux/copy where I need to convert lossless to lossy for better hardware compatibility.  

320 kbps per channel for AC3 stereo (640 kbps for 2 channels)  
256 kbps per channel for E-AC3 surround (1536 kbps for 6 (5.1) channels).  
  
**AC3_konverter_stereo_all_generic.cmd**  
Convert all tracks of given target video file.  
  
**EAC3_konverter_5.1_firststreamonly.cmd**  
Converts the first track only, and assumes it's at least 5.1(6 channels).  
This script also includes some notes I've made for personal reference on ffmpeg usage.  
  
**OPUS_konverter.cmd**  
Same as above, but with any number of channels from and to.  
  
**AC3_add_3_stereo_streams_from_first_with_metadata.cmd**  
Adds 3 downmixed stereo tracks, based on first track of given target video file.  
DD 2.0 Normalized - Has normalized levels.  
DD 2.0 HigherVoice - Has increased center channel boost for dialogue.  
DD 2.0 HigherVoiceLFE - Has increased center channel boost, but also normalized LFE.  
With this script, you'll also be able to assign visible language metadata.  
  
*Extract ffmpeg.rar before using any script (archived due to GitHub size limitations).*  
  
**Sonarr/Radarr**  
  
1. Go to Settings > Connect  
2. Add a connection.  
3. Name it whatever.  
4. Set type to *On File Import* and path to the respective 2ch or 6ch(5.1) script.  
5. Test it and verify results.  