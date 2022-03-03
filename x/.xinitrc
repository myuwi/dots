#!/bin/sh
xsetroot -cursor_name left_ptr

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

exec qtile start
