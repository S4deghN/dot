#!/bin/sh

de=${DE:-i3}

[ -f ~/.xprofile ] && . ~/.xprofile

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

pipewire &

if [ $de = "dwm" ]; then
    nitrogen --restore &
    picom --config ~/.config/picom/picom-dwm.conf &
    dwm-status &
    mate-polkit &
    xfce4-clipman &
elif [ $de = "i3" ]; then
    mate-polkit &
    xfce4-clipman &
elif [ $de = "xfce4" ]; then
    de=startxfce4
fi

dbus-update-activation-environment --all
exec ssh-agent "$de"
