#!/bin/sh

DE=dwm

[ -f ~/.xprofile ] && . ~/.xprofile

if [ $DE = "dwm" ]; then
    nitrogen --restore &
    picom --config ~/.config/picom/picom-dwm.conf &
    dwm-status &
    qlipper &
elif [ $DE = "i3" ]; then
    continue
fi

#Activate dbus variables
# dbus-update-activation-environment --all
exec dbus-launch --exit-with-session $DE
