#!/usr/bin/bash -x
configfile=/home/jpuellmann/.config/skippy-xd.rc
killall skippy-xd
rm /tmp/skippy-xd-fifo
skippy-xd --config $configfile --start-daemon
