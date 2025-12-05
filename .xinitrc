#!/bin/sh

de=${DE:-dwm}

[ -f ~/.xprofile ] && . ~/.xprofile

if [ $de = "dwm" ]; then
    nitrogen --restore &
    picom --config ~/.config/picom/picom-dwm.conf &
    dwm-status &
    qlipper &
elif [ $de = "i3" ]; then
    continue
fi

#Activate dbus variables
# dbus-update-activation-environment --all
exec dbus-launch --exit-with-session $de
