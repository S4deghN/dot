#!/bin/sh

# Module showing network traffic. Shows how much data has been received (RX) or
# transmitted (TX) since the fprevious time this script ran. So if run every
# second, gives network traffic per second.

update() {
    new=0
    for arg; do
        read -r i < "$arg"
        new=$(( new + i ))
    done
    fprev=/dev/shm/${1##*/}
    read -r prev < "$fprev" || prev=0
    printf %d\\n "$new" > "$fprev"
    printf %d\\n $(( new - prev ))
}

rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

# printf "%4sB/s %4sB/s" $(numfmt --to=si $rx $tx)
numfmt --to=si --format="%4fB/s" --field=1,2 "$rx $tx"
