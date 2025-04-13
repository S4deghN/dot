#!/bin/bash

now=$EPOCHSECONDS
tfile=/dev/shm/timer

if [ "$1" == "s" ]; then
  [ "$2" ] &&
    period=$(( $(date -d "$2" +%s) - now )) ||
    period=3600
  declare -A timer=(
  ["tprev"]=$now
  ["remain"]=$period
  ["period"]=$period
  ["paused"]=0)
  declare -p timer > $tfile
elif [ -f "$tfile" ]; then
  source $tfile

  case "$1" in
    p)
      if [ ${timer["paused"]} -eq 0 ]; then
        timer["paused"]=1
      else
        timer["paused"]=0
        timer["tprev"]=$now
      fi
      ;;
    r)
      timer["tprev"]=$now
      timer["remain"]=${timer["period"]}
      ;;
  esac


  if [ ${timer["paused"]} -eq 0 ]; then
    (( timer["remain"]-=(now-timer["tprev"]) ))
    timer["tprev"]=$now
  fi

  remain=${timer["remain"]}
  if [ $remain -gt 0 ]; then symbol="🍅 "
  else arr=("💢 -" "🍅 -"); symbol=${arr[$((remain%2))]}; ((remain=-remain))
  fi

  if [ $remain -ge 3600 ]; then
    printf "%s%dh%dm%ds\n" \
   "$symbol" $((remain / 3600)) $(((remain % 3600) / 60)) $((remain % 60))
  elif [ $remain -ge 60 ]; then
    printf "%s%dm%ds\n" "$symbol" $(((remain % 3600) / 60)) $((remain % 60))
  else
    printf "%s%ds\n" "$symbol" $((remain % 60))
  fi

  declare -p timer > $tfile
fi
