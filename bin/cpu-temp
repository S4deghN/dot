#!/bin/sh

# sed -nE 's/^([0-9][0-9])[0-9]*/\1°C/p' /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input

read tmp < $(echo /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input)
echo ${tmp%000}°C
