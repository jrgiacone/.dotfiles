#!/usr/bin/env bash
pkill picom
xrandr --output DP-4 --off
#sleep 1
#xrandr --output DP-2 --off
#xrandr --output DP-2 --mode 2560x1440 --rate 144 --primary --dpi 108
#sleep 2 
#i3-msg restart
nitrogen --force-setter=xinerama --restore
picom --experimental-backends
