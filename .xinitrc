#!/bin/sh

de=${DE:-xfce4}

[ -f ~/.xprofile ] && . ~/.xprofile

if [ $de = "dwm" ]; then
    nitrogen --restore &
    picom --config ~/.config/picom/picom-dwm.conf &
    dwm-status &
    xfce4-clipman &
    mate-polkit &
elif [ $de = "i3" ]; then
    continue
elif [ $de = "xfce4" ]; then
    de=startxfce4
fi

#Activate dbus variables
# dbus-update-activation-environment --all
exec dbus-launch --exit-with-session $de
