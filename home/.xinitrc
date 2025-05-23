#!/bin/sh
xrdb -merge ~/.Xresources
exec awesome >>~/.cache/awesome/stdout 2>>~/.cache/awesome/stderr
