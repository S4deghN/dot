#!/usr/bin/bash

# $TERMINAL -e bash -c "/home/s4/Games/skylords-reborn/drive_c/Program\ Files/BattleForge/skylords-upd.sh"

if [[ $? = 0  ]]; then
    UTRIS_SKIP_INIT=1 lutris lutris:rungame/skylords-reborn
else
    notify-send "update failed!"
fi
