#!/bin/sh
xrandr --output DP-0 --primary --mode 1920x1080 --rate 144.00 --pos 0x0 \
	--output DP-3 --mode 1920x1080 --rate 60.00 --pos -1920x200 \
	--output HDMI-0 --mode 1920x1080 --rate 60.00 --pos 1920x200
