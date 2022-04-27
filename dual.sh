#!/bin/bash
#xrandr --output DP-4 --off
pkill picom
xrandr --output DP-4 --mode 1920x1080 --rate 144 --dpi 92 --left-of DP-2
#xrandr --output DP-2 --mode 2560x1440 --rate 144 --primary --right-of DP-4 --dpi 108
#sleep 3
#i3-msg restart
nitrogen --force-setter=xinerama --restore
picom --experimental-backends
