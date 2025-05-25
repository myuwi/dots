#!/bin/sh
xrdb -merge ~/.Xresources
exec awesome >>/tmp/awesome.log 2>&1
