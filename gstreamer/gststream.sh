#!/bin/bash

VIDEODEV=/dev/video0
VIDEOCAPS='video/x-raw,framerate=30/1,width=1024,height=576'
AUDIODEV=hw:2
AUDIOCAPS='audio/x-raw,format=S16LE,channels=2,rate=48000'

gst-launch-1.0 \
    mpegtsmux name=mux \
    ! udpsink host=10.17.42.111 port=12345 \
    v4l2src device=$VIDEODEV do-timestamp=true \
    ! $VIDEOCAPS \
    ! videorate \
    ! queue \
    ! videoconvert \
    ! queue \
    ! x264enc speed-preset=superfast \
    ! queue \
    ! mux. \
    alsasrc device=$AUDIODEV do-timestamp=true provide-clock=false slave-method=0 \
    ! $AUDIOCAPS \
    ! queue \
    ! audioconvert \
    ! queue \
    ! voaacenc \
    ! queue \
    ! mux.
