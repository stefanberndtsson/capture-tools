# Usage: h264encode preset-name
function h264encode {
    preset="$1"
    if test "$preset" = ""
    then
        preset="medium"
    fi
    cat <<EOF
        ! x264enc speed-preset=$preset
EOF
}

# Usage: aacencode
function aacencode {
    cat <<EOF
        ! voaacenc
EOF
}

# Usage: hdmicapture device width height
function hdmicapture {
    device="$1"
    if test "$device" = ""
    then
        device=/dev/video0
    fi

    width="$2"
    if test "$width" = ""
    then
        width=1280
    fi

    height="$3"
    if test "$height" = ""
    then
        height=720
    fi
    cat <<EOF
        v4l2src device="$device" do-timestamp=true \
        ! video/x-raw,width=$width,height=$height \
        ! videorate \
        ! queue \
        ! videoconvert
EOF
}

# Usage: alsacapture device rate channels format
function alsacapture {
    device="$1"
    if test "$device" = ""
    then
        device=/dev/video0
    fi

    rate="$2"
    if test "$rate" = ""
    then
        rate=48000
    fi

    channels="$3"
    if test "$channels" = ""
    then
        channels=2
    fi

    format="$3"
    if test "$format" = ""
    then
        format=S16LE
    fi
    cat <<EOF
        alsasrc device=$device do-timestamp=true provide-clock=false slave-method=0 \
        ! audio/x-raw,format=$format,rate=$rate,channels=$channels \
        ! queue \
        ! audioconvert
EOF
}
