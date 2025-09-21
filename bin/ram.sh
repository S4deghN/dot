#!/bin/sh -e

set -- $(free -h --si -L)

printf '%s\n' $6
