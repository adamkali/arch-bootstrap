#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xmodmap ~/.config/swap_esc &

if [[ $(xrandr | awk '/Virtual-1/ {print $2}') == "connected" ]]; then 
    xrandr --output Virtual-1 --mode 1920x1080 
    exec leftwm
else
    exec leftwm 
fi
