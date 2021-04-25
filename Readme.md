# Youtube live stream (full hd) with raspberry pi 3


This simple script lets you stream live from your RaspberryPi 3 (or higher) with
RaspberryPi camera module to Google Youtube livestream.


CPU load of the ffmpeg process is about 30%. H264 complession is done
in hardware, so ffmpeg only has to generate pts (timecode) and 
multiplex (zero audio and video) into flv stream

FullHD is possible. At least when the RaspberryPi is connected by ethernet cable.


