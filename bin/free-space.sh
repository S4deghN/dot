#!/bin/sh -e

output=$(df / --si -h --output=avail)

printf '%s\n' ${output##Avail}
