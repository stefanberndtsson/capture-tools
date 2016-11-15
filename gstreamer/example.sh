#!/bin/bash -x

source ./cmds.sh

gst-launch-1.0 \
    mpegtsmux name=mux \
    ! udpsink host=127.0.0.1 port=12345 \
    $(hdmicapture /dev/video0 1920 1080) \
    ! queue \
    $(h264encode superfast) \
    ! queue \
    ! mux. \
    $(alsacapture hw:2 48000) \
    ! queue \
    $(aacencode) \
    ! queue \
    ! mux.
