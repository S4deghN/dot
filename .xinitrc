#!/bin/sh

de=${DE:-i3}

exec 1>"$HOME/.session.log"
exec 2>&1

[ -f ~/.xprofile ] && . ~/.xprofile

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

    pkill -U $(id -u) -f "dbus-daemon.*--session" || true
    dbus-daemon --session --address="unix:path=${XDG_RUNTIME_DIR}/bus" --fork --syslog || exit 1
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
