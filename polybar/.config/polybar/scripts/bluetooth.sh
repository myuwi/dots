#!/bin/bash
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
    echo "Off"
else
    echo $(bluetoothctl paired-devices | cut -d' ' -f2 | xargs -I{} -n1 bash -c "bluetoothctl info {} | grep -s 'Connected: yes'" | wc -l)
fi
