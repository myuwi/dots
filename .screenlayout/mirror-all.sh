#!/bin/sh
xrandr --listmonitors |
	sed -n '1!p' |
	sed -e 's/\s[0-9].*\s\([a-zA-Z0-9\-]*\)$/\1/g' |
	xargs -I{} -- bash -xc 'xrandr --output {} --mode "1920x1080" --pos 0x0 --rotate normal'
