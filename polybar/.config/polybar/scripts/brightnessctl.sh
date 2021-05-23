#!/bin/bash
brightness_level=$(brightnessctl g)
brightness_max=$(brightnessctl m)
brightness_percent_rounded=$(((($brightness_level * 100 / $brightness_max) + 2) / 5 * 5))

# brightness_percent=$((($brightness_level * 100 / $brightness_max)))

echo "$brightness_percent_rounded%"
