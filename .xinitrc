#!/bin/sh

[ -f ~/.xprofile ] && . ~/.xprofile

# dbus-update-activation-environment --all
exec dbus-launch --exit-with-session i3
