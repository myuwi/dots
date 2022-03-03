#!/bin/bash
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -r bspwm &

if [[ $(hostname) = "archdesktop" ]]; then
    polybar -r bspwm-left &
    polybar -r bspwm-right &
fi

echo "Polybar launched..."
