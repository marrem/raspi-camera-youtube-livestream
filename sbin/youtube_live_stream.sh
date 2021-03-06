#!/bin/bash

# Date/time in strftime
ANNOTATE_TEMPLATE='Oak tree cam. Netherlands, The Hague, %Y-%m-%d %H:%M:%S %z'
STREAM_KEY="$1"

if [ -z "$STREAM_KEY" ];then
	echo "$0 <youtube stream key>" >&2
	exit 1
fi

INPUT_VIDEO_WIDTH=1920
INPUT_VIDEO_HEIGHT=1080
INPUT_VIDEO_BITRATE=8000000
INPUT_VIDEO_FRAMERATE=30
INPUT_VIDEO_KEYFRAME_INTERVAL=40
INPUT_VIDEO_FORMAT=h264

INPUT_AUDIO_BITRATE=44100
INPUT_AUDIO_NROFCHANNELS=2
INPUT_AUDIO_FORMAT=s16le

INPUT_THREAD_QUEUE_SIZE=128

OUTPUT_VIDEO_KEYFRAME_INTERVAL=40
OUTPUT_VIDEO_FRAMERATE=30

OUTPUT_FORMAT=flv
OUTPUT_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

set -o pipefail

raspivid -o - -t 0 \
  --annotate 12 \
  --annotate "$ANNOTATE_TEMPLATE" \
  -b $INPUT_VIDEO_BITRATE \
  -w $INPUT_VIDEO_WIDTH \
  -h $INPUT_VIDEO_HEIGHT \
  -fps $INPUT_VIDEO_FRAMERATE \
  -g $INPUT_VIDEO_KEYFRAME_INTERVAL | \
ffmpeg \
  -hide_banner \
  -loglevel error \
  -re \
  -ar $INPUT_AUDIO_BITRATE \
  -ac $INPUT_AUDIO_NROFCHANNELS \
  -f $INPUT_AUDIO_FORMAT \
  -i /dev/zero \
  -f $INPUT_VIDEO_FORMAT \
  -use_wallclock_as_timestamps 1 \
  -thread_queue_size $INPUT_THREAD_QUEUE_SIZE \
  -i pipe:0 \
  -vcodec copy \
  -acodec aac \
  -ab 128k \
  -g $OUTPUT_VIDEO_KEYFRAME_INTERVAL \
  -strict experimental \
  -f $OUTPUT_FORMAT \
  -r $OUTPUT_VIDEO_FRAMERATE \
  $OUTPUT_URL

