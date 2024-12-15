#!/bin/bash -e

bat_dir=/sys/class/power_supply/BAT0

[[ ! -d $bat_dir ]] && exit 0

declare -A status_map=(
    ["Unknown"]="❗"
    ["Charging"]="⚡"
    ["Discharging"]="🪫"
    ["Not charging"]="🔌"
    ["Full"]="🔋"
)


read -r capacity < $bat_dir/capacity
read -r status   < $bat_dir/status

printf '%s %s%%\n' "${status_map[$status]}" "$capacity"
