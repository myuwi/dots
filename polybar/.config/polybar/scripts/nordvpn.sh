#!/bin/bash
status=$(nordvpn status)

if grep -q "Status: Disconnected" <<<$status; then
    echo "Off"
else
    server=$((grep -s 'Current server' <<<$status) | cut -d' ' -f3 | cut -d'.' -f1)

    echo "$server"
fi
