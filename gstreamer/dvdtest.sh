#!/bin/bash

DEVICE=$1
TITLE=$2
if test "$DEVICE" = ""
then
    echo Usage: $0 dvd-device/isofile [titlenum]
    exit 0
fi

if test "$TITLE" = ""
then
    TITLE="1"
fi

gst-launch-1.0 \
    dvdreadsrc device=$DEVICE title=$TITLE chapter=3 \
    ! tee name=dvd \
    dvd. \
    ! mpegpsdemux \
    ! 'video/mpeg,mpegversion=2' \
    ! mpeg2dec \
    ! queue \
    ! videoconvert \
    ! deinterlace \
    ! videoconvert \
    ! queue \
    ! x264enc speed-preset=superfast \
    ! mux. \
    dvd. \
    ! mpegpsdemux \
    ! 'audio/x-private1-ac3' \
    ! a52dec \
    ! audioconvert \
    ! lamemp3enc target=bitrate bitrate=128 \
    ! queue \
    ! mux. \
    matroskamux name=mux \
    ! queue \
    ! filesink location=/tmp/dump.mkv 
